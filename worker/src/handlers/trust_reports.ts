import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";

// ── Reference-number generation ──────────────────────────────────────────────
// Increments the singleton sequence row and returns a formatted public reference
// such as TCR-2025-00042.

async function generateReference(env: Env): Promise<string> {
  const year = new Date().getFullYear().toString();
  let seq = 1;
  try {
    const row = await env.DB.prepare(
      "UPDATE trust_report_sequence SET next_val = next_val + 1 WHERE id = 1 RETURNING next_val",
    ).first<{ next_val: number }>();
    if (row) seq = row.next_val;
  } catch {
    // Fallback: read then set (D1 may not support RETURNING in all environments)
    const r = await env.DB.prepare(
      "SELECT next_val FROM trust_report_sequence WHERE id = 1",
    ).first<{ next_val: number }>();
    seq = r ? r.next_val : 1;
    await env.DB.prepare(
      "UPDATE trust_report_sequence SET next_val = next_val + 1 WHERE id = 1",
    ).run();
  }
  return `TCR-${year}-${String(seq).padStart(5, "0")}`;
}

// ── R2 upload for official documents ─────────────────────────────────────────

async function uploadOfficialFile(
  env: Env,
  file: File,
  reportId: string,
  route: string,
  attachmentId: string,
): Promise<{ r2Key: string; originalFilename: string; contentType: string; sizeBytes: number }> {
  const r2Key = `trust-reports/${reportId}/${attachmentId}`;
  const bytes = await file.arrayBuffer();
  const contentType = file.type || "application/octet-stream";
  await env.CICWTCH_ATTACHMENTS.put(r2Key, bytes, {
    httpMetadata: { contentType },
    customMetadata: { route, reportId },
  });
  return {
    r2Key,
    originalFilename: file.name || "upload",
    contentType,
    sizeBytes: bytes.byteLength,
  };
}

// ── Store attachment metadata in D1 ─────────────────────────────────────────

async function storeAttachmentMetadata(
  env: Env,
  params: {
    id: string;
    reportId: string;
    reportReference: string;
    originalFilename: string;
    contentType: string;
    sizeBytes: number;
    r2Key: string;
    route: string;
    uploadedAt: string;
  },
): Promise<void> {
  await env.DB.prepare(
    `INSERT INTO trust_report_attachments
       (id, report_id, report_reference, original_filename, content_type, file_size_bytes, r2_key, route, uploaded_at)
     VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)`,
  )
    .bind(
      params.id,
      params.reportId,
      params.reportReference,
      params.originalFilename,
      params.contentType,
      params.sizeBytes,
      params.r2Key,
      params.route,
      params.uploadedAt,
    )
    .run();
}

// ── Record an audit event ─────────────────────────────────────────────────────

async function recordEvent(
  env: Env,
  reportId: string,
  eventType: string,
  detail?: string,
): Promise<void> {
  await env.DB.prepare(
    `INSERT INTO trust_report_events (id, report_id, occurred_at, event_type, actor, detail)
     VALUES (?1, ?2, ?3, ?4, ?5, ?6)`,
  )
    .bind(
      crypto.randomUUID(),
      reportId,
      new Date().toISOString(),
      eventType,
      "system",
      detail ?? null,
    )
    .run();
}

// ── Public/standard trust report submission ──────────────────────────────────
// Accepts JSON. Used for all non-official routes (client, accessibility, rights).

export async function submitTrustReport(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = (await request.json()) as Record<string, unknown>;
  } catch {
    return jsonError("Request body must be valid JSON", "invalid_request", 400);
  }

  const str = (key: string): string =>
    typeof body[key] === "string" ? (body[key] as string).trim() : "";
  const optStr = (key: string): string | null => str(key) || null;

  const route = str("route");
  const name = str("name");
  const email = str("email");

  if (!route) return jsonError("route is required", "invalid_request", 400);
  if (!name) return jsonError("name is required", "invalid_request", 400);
  if (!email) return jsonError("email is required", "invalid_request", 400);

  const now = new Date().toISOString();
  const id = crypto.randomUUID();
  const reference = await generateReference(env);

  const supportingLinks = Array.isArray(body["supporting_links"])
    ? JSON.stringify(body["supporting_links"])
    : null;

  const helpType = optStr("help_type");
  const priority =
    helpType === "harmful" ? "high" : "normal";

  try {
    await env.DB.prepare(
      `INSERT INTO trust_reports (
        id, reference, created_at, updated_at, submitted_at,
        status, priority, role_type, help_type,
        reporter_name, reporter_email, reporter_phone, organisation_name,
        description, requested_outcome, supporting_links, preferred_contact, form_data
      ) VALUES (
        ?1, ?2, ?3, ?4, ?5,
        'open', ?6, ?7, ?8,
        ?9, ?10, ?11, ?12,
        ?13, ?14, ?15, ?16, ?17
      )`,
    )
      .bind(
        id, reference, now, now, now,
        priority, route, helpType,
        name, email, optStr("phone"), optStr("organisation"),
        str("description"), optStr("requested_outcome"), supportingLinks,
        optStr("preferred_contact"),
        JSON.stringify(body),
      )
      .run();

    await recordEvent(env, id, "created", `Route: ${route}`);
  } catch (err) {
    const msg = err instanceof Error ? err.message : "Unknown error";
    return jsonError("Failed to store report: " + msg, "internal_error", 500);
  }

  return jsonOk({ id, reference, status: "open" }, 201);
}

// ── Official trust report submission ─────────────────────────────────────────
// Accepts multipart/form-data. Used for police/emergency and regulator/legal routes.
// Uploads attached files to R2 and stores metadata in D1.

export async function submitOfficialTrustReport(
  request: Request,
  env: Env,
): Promise<Response> {
  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonError(
      "Request must be multipart/form-data",
      "invalid_request",
      400,
    );
  }

  const str = (key: string): string => {
    const v = formData.get(key);
    return typeof v === "string" ? v.trim() : "";
  };
  const optStr = (key: string): string | null => str(key) || null;

  const route = str("route");
  if (route !== "police" && route !== "regulator") {
    return jsonError(
      "route must be police or regulator for official submissions",
      "invalid_request",
      400,
    );
  }

  const name = str("name");
  const email = str("email");
  const description = str("description");

  if (!name) return jsonError("name is required", "invalid_request", 400);
  if (!email) return jsonError("email is required", "invalid_request", 400);
  if (!description) return jsonError("description is required", "invalid_request", 400);

  const riskToLife = optStr("risk_to_life");
  const avoidNotification = optStr("avoid_notification");

  const priority =
    riskToLife === "yes" ? "urgent" : "high";

  const now = new Date().toISOString();
  const id = crypto.randomUUID();
  const reference = await generateReference(env);

  const policeFields =
    route === "police"
      ? {
          collar_number: optStr("collar_number"),
          force_name: optStr("force"),
          station_unit: optStr("station"),
          cad_number: optStr("cad_number"),
          crime_reference: optStr("crime_ref"),
          risk_to_life: riskToLife,
          avoid_notification: avoidNotification,
          official_role: optStr("role"),
        }
      : {};

  const regulatorFields =
    route === "regulator"
      ? {
          regulator_ref: optStr("official_ref"),
          official_role: optStr("role"),
          organisation_name: optStr("organisation"),
        }
      : {};

  try {
    await env.DB.prepare(
      `INSERT INTO trust_reports (
        id, reference, created_at, updated_at, submitted_at,
        status, priority, role_type,
        reporter_name, reporter_email, reporter_phone,
        organisation_name, official_role, official_ref,
        collar_number, force_name, station_unit, cad_number, crime_reference,
        risk_to_life, avoid_notification,
        regulator_ref,
        description, form_data
      ) VALUES (
        ?1, ?2, ?3, ?4, ?5,
        'open', ?6, ?7,
        ?8, ?9, ?10,
        ?11, ?12, ?13,
        ?14, ?15, ?16, ?17, ?18,
        ?19, ?20,
        ?21,
        ?22, ?23
      )`,
    )
      .bind(
        id, reference, now, now, now,
        priority, route,
        name, email, optStr("phone"),
        regulatorFields.organisation_name ?? optStr("force") ?? null,
        policeFields.official_role ?? regulatorFields.official_role ?? null,
        regulatorFields.regulator_ref ?? null,
        policeFields.collar_number ?? null,
        policeFields.force_name ?? null,
        policeFields.station_unit ?? null,
        policeFields.cad_number ?? null,
        policeFields.crime_reference ?? null,
        policeFields.risk_to_life ?? null,
        policeFields.avoid_notification ?? null,
        regulatorFields.regulator_ref ?? null,
        description,
        JSON.stringify(Object.fromEntries(
          [...formData.entries()].filter(([, v]) => typeof v === "string"),
        )),
      )
      .run();

    await recordEvent(env, id, "created", `Official route: ${route}`);
  } catch (err) {
    const msg = err instanceof Error ? err.message : "Unknown error";
    return jsonError("Failed to store report: " + msg, "internal_error", 500);
  }

  // Upload attached files to R2 and store metadata in D1
  const fileEntries = formData.getAll("files");
  for (const entry of fileEntries) {
    if (typeof entry === "string") continue;
    const file = entry as unknown as File;
    if (!file || typeof (file as unknown as { arrayBuffer?: unknown }).arrayBuffer !== "function") continue;
    const attachmentId = crypto.randomUUID();
    try {
      const uploaded = await uploadOfficialFile(env, file, id, route, attachmentId);
      await storeAttachmentMetadata(env, {
        id: attachmentId,
        reportId: id,
        reportReference: reference,
        originalFilename: uploaded.originalFilename,
        contentType: uploaded.contentType,
        sizeBytes: uploaded.sizeBytes,
        r2Key: uploaded.r2Key,
        route,
        uploadedAt: now,
      });
      await recordEvent(env, id, "attachment_added", uploaded.originalFilename);
    } catch {
      // Non-fatal: log but continue processing other files
      await recordEvent(env, id, "attachment_error", file.name || "unknown");
    }
  }

  return jsonOk({ id, reference, status: "open", priority }, 201);
}

// ── Contact Us submission ─────────────────────────────────────────────────────
// Accepts JSON from the contact-us page. Stored as a trust report with role 'contact'.

export async function submitContactMessage(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = (await request.json()) as Record<string, unknown>;
  } catch {
    return jsonError("Request body must be valid JSON", "invalid_request", 400);
  }

  const str = (key: string): string =>
    typeof body[key] === "string" ? (body[key] as string).trim() : "";
  const optStr = (key: string): string | null => str(key) || null;

  const name = str("name");
  const email = str("email");
  const message = str("message");

  if (!name) return jsonError("name is required", "invalid_request", 400);
  if (!email) return jsonError("email is required", "invalid_request", 400);
  if (!message) return jsonError("message is required", "invalid_request", 400);

  const now = new Date().toISOString();
  const id = crypto.randomUUID();
  const reference = await generateReference(env);

  try {
    await env.DB.prepare(
      `INSERT INTO trust_reports (
        id, reference, created_at, updated_at, submitted_at,
        status, priority, role_type,
        reporter_name, reporter_email,
        description, form_data
      ) VALUES (
        ?1, ?2, ?3, ?4, ?5,
        'open', 'normal', 'contact',
        ?6, ?7,
        ?8, ?9
      )`,
    )
      .bind(
        id, reference, now, now, now,
        name, email,
        `[Subject: ${optStr("subject") ?? "General"}] ${message}`,
        JSON.stringify(body),
      )
      .run();

    await recordEvent(env, id, "created", "Contact form submission");
  } catch (err) {
    const msg = err instanceof Error ? err.message : "Unknown error";
    return jsonError("Failed to store message: " + msg, "internal_error", 500);
  }

  return jsonOk({ id, reference }, 201);
}
