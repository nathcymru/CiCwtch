import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

const VALID_STATUS_VALUES = [
  "planned",
  "in_progress",
  "completed",
  "cancelled",
] as const;

interface WalkRow {
  id: string;
  client_id: string;
  dog_id: string;
  walker_id: string | null;
  scheduled_date: string;
  scheduled_start_time: string | null;
  scheduled_end_time: string | null;
  actual_start_time: string | null;
  actual_end_time: string | null;
  status: string;
  service_type: string;
  pickup_address_id: string | null;
  notes: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

export async function listWalks(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM walks WHERE archived_at IS NULL ORDER BY scheduled_date ASC, scheduled_start_time ASC",
  ).all<WalkRow>();
  return jsonOk(results ?? []);
}

export async function getWalk(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const walk = await env.DB.prepare(
    "SELECT * FROM walks WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkRow>();

  if (!walk) {
    throw ApiError.notFound();
  }

  return jsonOk(walk);
}

export async function createWalk(
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
    .bind(clientId)
    .first<{ id: string }>();

  if (!clientExists) {
    return jsonError("client not found", "invalid_request", 400);
  }

  const dogId = body["dog_id"];
  if (typeof dogId !== "string" || dogId.trim() === "") {
    return jsonError("dog_id is required", "invalid_request", 400);
  }

  const dogExists = await env.DB.prepare(
    "SELECT id FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(dogId)
    .first<{ id: string }>();

  if (!dogExists) {
    return jsonError("dog not found", "invalid_request", 400);
  }

  const scheduledDate = body["scheduled_date"];
  if (typeof scheduledDate !== "string" || scheduledDate.trim() === "") {
    return jsonError("scheduled_date is required", "invalid_request", 400);
  }

  const walkerIdValue = body["walker_id"];
  let walkerId: string | null = null;
  if (
    walkerIdValue !== undefined &&
    walkerIdValue !== null &&
    walkerIdValue !== ""
  ) {
    if (typeof walkerIdValue !== "string") {
      return jsonError("walker_id must be a string", "invalid_request", 400);
    }
    const walkerExists = await env.DB.prepare(
      "SELECT id FROM walkers WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(walkerIdValue)
      .first<{ id: string }>();

    if (!walkerExists) {
      return jsonError("walker not found", "invalid_request", 400);
    }
    walkerId = walkerIdValue;
  }

  const statusValue = body["status"];
  if (
    statusValue !== undefined &&
    statusValue !== null &&
    (typeof statusValue !== "string" ||
      !VALID_STATUS_VALUES.includes(
        statusValue as (typeof VALID_STATUS_VALUES)[number],
      ))
  ) {
    return jsonError(
      "status must be one of: planned, in_progress, completed, cancelled",
      "invalid_request",
      400,
    );
  }

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const walk: WalkRow = {
    id,
    client_id: clientId.trim(),
    dog_id: dogId.trim(),
    walker_id: walkerId,
    scheduled_date: scheduledDate.trim(),
    scheduled_start_time: optionalString(body, "scheduled_start_time"),
    scheduled_end_time: optionalString(body, "scheduled_end_time"),
    actual_start_time: optionalString(body, "actual_start_time"),
    actual_end_time: optionalString(body, "actual_end_time"),
    status:
      typeof statusValue === "string" && statusValue ? statusValue : "planned",
    service_type:
      typeof body["service_type"] === "string" && body["service_type"]
        ? (body["service_type"] as string)
        : "walk",
    pickup_address_id: optionalString(body, "pickup_address_id"),
    notes: optionalString(body, "notes"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO walks (
      id, client_id, dog_id, walker_id, scheduled_date, scheduled_start_time,
      scheduled_end_time, actual_start_time, actual_end_time, status, service_type,
      pickup_address_id, notes, archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14, ?15, ?16)`,
  )
    .bind(
      walk.id,
      walk.client_id,
      walk.dog_id,
      walk.walker_id,
      walk.scheduled_date,
      walk.scheduled_start_time,
      walk.scheduled_end_time,
      walk.actual_start_time,
      walk.actual_end_time,
      walk.status,
      walk.service_type,
      walk.pickup_address_id,
      walk.notes,
      walk.archived_at,
      walk.created_at,
      walk.updated_at,
    )
    .run();

  return jsonOk(walk, 201);
}

export async function updateWalk(
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

  const scheduledDate = body["scheduled_date"];
  if (typeof scheduledDate !== "string" || scheduledDate.trim() === "") {
    return jsonError("scheduled_date is required", "invalid_request", 400);
  }

  const existing = await env.DB.prepare(
    "SELECT * FROM walks WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkRow>();

  if (!existing) {
    throw ApiError.notFound();
  }

  let clientId = existing.client_id;
  if ("client_id" in body) {
    const bodyClientId = body["client_id"];
    if (typeof bodyClientId !== "string" || bodyClientId.trim() === "") {
      return jsonError("client_id is required", "invalid_request", 400);
    }
    clientId = bodyClientId.trim();

    const clientExists = await env.DB.prepare(
      "SELECT id FROM clients WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(clientId)
      .first<{ id: string }>();

    if (!clientExists) {
      return jsonError("client not found", "invalid_request", 400);
    }
  }

  let dogId = existing.dog_id;
  if ("dog_id" in body) {
    const bodyDogId = body["dog_id"];
    if (typeof bodyDogId !== "string" || bodyDogId.trim() === "") {
      return jsonError("dog_id is required", "invalid_request", 400);
    }
    dogId = bodyDogId.trim();

    const dogExists = await env.DB.prepare(
      "SELECT id FROM dogs WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(dogId)
      .first<{ id: string }>();

    if (!dogExists) {
      return jsonError("dog not found", "invalid_request", 400);
    }
  }

  let walkerId: string | null = existing.walker_id;
  if ("walker_id" in body) {
    const bodyWalkerId = body["walker_id"];
    if (
      bodyWalkerId !== null &&
      bodyWalkerId !== "" &&
      bodyWalkerId !== undefined
    ) {
      if (typeof bodyWalkerId !== "string") {
        return jsonError("walker_id must be a string", "invalid_request", 400);
      }
      const walkerExists = await env.DB.prepare(
        "SELECT id FROM walkers WHERE id = ?1 AND archived_at IS NULL",
      )
        .bind(bodyWalkerId)
        .first<{ id: string }>();

      if (!walkerExists) {
        return jsonError("walker not found", "invalid_request", 400);
      }
      walkerId = bodyWalkerId;
    } else {
      walkerId = null;
    }
  }

  const statusValue = body["status"];
  if (
    statusValue !== undefined &&
    statusValue !== null &&
    (typeof statusValue !== "string" ||
      !VALID_STATUS_VALUES.includes(
        statusValue as (typeof VALID_STATUS_VALUES)[number],
      ))
  ) {
    return jsonError(
      "status must be one of: planned, in_progress, completed, cancelled",
      "invalid_request",
      400,
    );
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    `UPDATE walks SET
      client_id = ?1,
      dog_id = ?2,
      walker_id = ?3,
      scheduled_date = ?4,
      scheduled_start_time = ?5,
      scheduled_end_time = ?6,
      actual_start_time = ?7,
      actual_end_time = ?8,
      status = ?9,
      service_type = ?10,
      pickup_address_id = ?11,
      notes = ?12,
      updated_at = ?13
    WHERE id = ?14 AND archived_at IS NULL`,
  )
    .bind(
      clientId,
      dogId,
      walkerId,
      scheduledDate.trim(),
      optionalString(body, "scheduled_start_time") ??
        ("scheduled_start_time" in body
          ? null
          : existing.scheduled_start_time),
      optionalString(body, "scheduled_end_time") ??
        ("scheduled_end_time" in body ? null : existing.scheduled_end_time),
      optionalString(body, "actual_start_time") ??
        ("actual_start_time" in body ? null : existing.actual_start_time),
      optionalString(body, "actual_end_time") ??
        ("actual_end_time" in body ? null : existing.actual_end_time),
      typeof statusValue === "string" && statusValue
        ? statusValue
        : existing.status,
      typeof body["service_type"] === "string" && body["service_type"]
        ? (body["service_type"] as string)
        : existing.service_type,
      optionalString(body, "pickup_address_id") ??
        ("pickup_address_id" in body ? null : existing.pickup_address_id),
      optionalString(body, "notes") ?? ("notes" in body ? null : existing.notes),
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM walks WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteWalk(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM walks WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    "UPDATE walks SET archived_at = ?1, updated_at = ?2 WHERE id = ?3 AND archived_at IS NULL",
  )
    .bind(now, now, params.id)
    .run();

  return jsonOk({ deleted: true });
}
