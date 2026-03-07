import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

interface WalkerRow {
  id: string;
  full_name: string;
  phone: string | null;
  email: string | null;
  role_title: string | null;
  start_date: string | null;
  active: number;
  notes: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

export async function listWalkers(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM walkers WHERE archived_at IS NULL ORDER BY full_name ASC",
  ).all<WalkerRow>();
  return jsonOk(results ?? []);
}

export async function getWalker(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const walker = await env.DB.prepare(
    "SELECT * FROM walkers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkerRow>();

  if (!walker) {
    throw ApiError.notFound();
  }

  return jsonOk(walker);
}

export async function createWalker(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const fullName = body["full_name"];
  if (typeof fullName !== "string" || fullName.trim() === "") {
    return jsonError("full_name is required", "invalid_request", 400);
  }

  let active = 1;
  if (body["active"] !== undefined && body["active"] !== null) {
    if (body["active"] !== 0 && body["active"] !== 1) {
      return jsonError("active must be 0 or 1", "invalid_request", 400);
    }
    active = body["active"] as number;
  }

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const walker: WalkerRow = {
    id,
    full_name: fullName.trim(),
    phone: optionalString(body, "phone"),
    email: optionalString(body, "email"),
    role_title: optionalString(body, "role_title"),
    start_date: optionalString(body, "start_date"),
    active,
    notes: optionalString(body, "notes"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO walkers (
      id, full_name, phone, email, role_title, start_date,
      active, notes, archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11)`,
  )
    .bind(
      walker.id,
      walker.full_name,
      walker.phone,
      walker.email,
      walker.role_title,
      walker.start_date,
      walker.active,
      walker.notes,
      walker.archived_at,
      walker.created_at,
      walker.updated_at,
    )
    .run();

  return jsonOk(walker, 201);
}

export async function updateWalker(
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

  const fullName = body["full_name"];
  if (typeof fullName !== "string" || fullName.trim() === "") {
    return jsonError("full_name is required", "invalid_request", 400);
  }

  if (
    body["active"] !== undefined &&
    body["active"] !== null &&
    body["active"] !== 0 &&
    body["active"] !== 1
  ) {
    return jsonError("active must be 0 or 1", "invalid_request", 400);
  }

  const existing = await env.DB.prepare(
    "SELECT * FROM walkers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkerRow>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const active =
    body["active"] === 0 || body["active"] === 1
      ? (body["active"] as number)
      : existing.active;

  const now = new Date().toISOString();

  await env.DB.prepare(
    `UPDATE walkers SET
      full_name = ?1,
      phone = ?2,
      email = ?3,
      role_title = ?4,
      start_date = ?5,
      active = ?6,
      notes = ?7,
      updated_at = ?8
    WHERE id = ?9 AND archived_at IS NULL`,
  )
    .bind(
      fullName.trim(),
      optionalString(body, "phone"),
      optionalString(body, "email"),
      optionalString(body, "role_title"),
      optionalString(body, "start_date"),
      active,
      optionalString(body, "notes"),
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM walkers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<WalkerRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteWalker(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM walkers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    "UPDATE walkers SET archived_at = ?1, updated_at = ?2 WHERE id = ?3 AND archived_at IS NULL",
  )
    .bind(now, now, params.id)
    .run();

  return jsonOk({ deleted: true });
}
