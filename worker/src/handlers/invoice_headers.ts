import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

const VALID_STATUS_VALUES = ["draft", "issued", "paid", "cancelled"] as const;

interface InvoiceHeaderRow {
  id: string;
  client_id: string;
  invoice_number: string;
  status: string;
  issue_date: string | null;
  due_date: string | null;
  currency_code: string;
  notes: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

export async function listInvoiceHeaders(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM invoice_headers WHERE archived_at IS NULL ORDER BY created_at DESC",
  ).all<InvoiceHeaderRow>();
  return jsonOk(results ?? []);
}

export async function getInvoiceHeader(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const header = await env.DB.prepare(
    "SELECT * FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<InvoiceHeaderRow>();

  if (!header) {
    throw ApiError.notFound();
  }

  return jsonOk(header);
}

export async function createInvoiceHeader(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const clientId = body["client_id"];
  if (typeof clientId !== "string" || clientId.trim() === "") {
    return jsonError("client_id is required", "invalid_request", 400);
  }

  const clientExists = await env.DB.prepare(
    "SELECT id FROM clients WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(clientId.trim())
    .first<{ id: string }>();

  if (!clientExists) {
    return jsonError("client not found", "invalid_request", 400);
  }

  const invoiceNumber = body["invoice_number"];
  if (typeof invoiceNumber !== "string" || invoiceNumber.trim() === "") {
    return jsonError("invoice_number is required", "invalid_request", 400);
  }

  const duplicateNumber = await env.DB.prepare(
    "SELECT id FROM invoice_headers WHERE invoice_number = ?1",
  )
    .bind(invoiceNumber.trim())
    .first<{ id: string }>();

  if (duplicateNumber) {
    return jsonError(
      "invoice_number already exists",
      "invalid_request",
      400,
    );
  }

  const statusValue = body["status"];
  if (statusValue !== undefined && statusValue !== null) {
    if (
      typeof statusValue !== "string" ||
      !(VALID_STATUS_VALUES as readonly string[]).includes(statusValue)
    ) {
      return jsonError(
        "status must be one of: draft, issued, paid, cancelled",
        "invalid_request",
        400,
      );
    }
  }

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const header: InvoiceHeaderRow = {
    id,
    client_id: clientId.trim(),
    invoice_number: invoiceNumber.trim(),
    status:
      typeof statusValue === "string" && statusValue ? statusValue : "draft",
    issue_date: optionalString(body, "issue_date"),
    due_date: optionalString(body, "due_date"),
    currency_code:
      typeof body["currency_code"] === "string" && body["currency_code"]
        ? (body["currency_code"] as string)
        : "GBP",
    notes: optionalString(body, "notes"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO invoice_headers (
      id, client_id, invoice_number, status, issue_date, due_date,
      currency_code, notes, archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)`,
  )
    .bind(
      header.id,
      header.client_id,
      header.invoice_number,
      header.status,
      header.issue_date,
      header.due_date,
      header.currency_code,
      header.notes,
      header.archived_at,
      header.created_at,
      header.updated_at,
    )
    .run();

  return jsonOk(header, 201);
}

export async function updateInvoiceHeader(
  request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const existing = await env.DB.prepare(
    "SELECT * FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<InvoiceHeaderRow>();

  if (!existing) {
    throw ApiError.notFound();
  }

  if (body["client_id"] !== undefined) {
    const clientId = body["client_id"];
    if (typeof clientId !== "string" || clientId.trim() === "") {
      return jsonError("client_id is required", "invalid_request", 400);
    }
    const clientExists = await env.DB.prepare(
      "SELECT id FROM clients WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(clientId.trim())
      .first<{ id: string }>();
    if (!clientExists) {
      return jsonError("client not found", "invalid_request", 400);
    }
  }

  const statusValue = body["status"];
  if (statusValue !== undefined && statusValue !== null) {
    if (
      typeof statusValue !== "string" ||
      !(VALID_STATUS_VALUES as readonly string[]).includes(statusValue)
    ) {
      return jsonError(
        "status must be one of: draft, issued, paid, cancelled",
        "invalid_request",
        400,
      );
    }
  }

  const now = new Date().toISOString();

  const clientId =
    typeof body["client_id"] === "string" && body["client_id"]
      ? (body["client_id"] as string).trim()
      : existing.client_id;

  const invoiceNumber =
    typeof body["invoice_number"] === "string" && body["invoice_number"]
      ? (body["invoice_number"] as string).trim()
      : existing.invoice_number;

  const status =
    typeof statusValue === "string" && statusValue
      ? statusValue
      : existing.status;

  await env.DB.prepare(
    `UPDATE invoice_headers SET
      client_id = ?1,
      invoice_number = ?2,
      status = ?3,
      issue_date = ?4,
      due_date = ?5,
      currency_code = ?6,
      notes = ?7,
      updated_at = ?8
    WHERE id = ?9 AND archived_at IS NULL`,
  )
    .bind(
      clientId,
      invoiceNumber,
      status,
      body["issue_date"] !== undefined
        ? optionalString(body, "issue_date")
        : existing.issue_date,
      body["due_date"] !== undefined
        ? optionalString(body, "due_date")
        : existing.due_date,
      typeof body["currency_code"] === "string" && body["currency_code"]
        ? (body["currency_code"] as string)
        : existing.currency_code,
      body["notes"] !== undefined
        ? optionalString(body, "notes")
        : existing.notes,
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<InvoiceHeaderRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteInvoiceHeader(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    "UPDATE invoice_headers SET archived_at = ?1, updated_at = ?2 WHERE id = ?3 AND archived_at IS NULL",
  )
    .bind(now, now, params.id)
    .run();

  return jsonOk({ success: true });
}
