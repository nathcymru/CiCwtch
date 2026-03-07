import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

interface ClientRow {
  id: string;
  full_name: string;
  preferred_name: string | null;
  phone: string | null;
  email: string | null;
  address_id: string | null;
  emergency_contact_name: string | null;
  emergency_contact_phone: string | null;
  notes: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

export async function listClients(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM clients WHERE archived_at IS NULL ORDER BY full_name ASC",
  ).all<ClientRow>();
  return jsonOk(results ?? []);
}

export async function getClient(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const client = await env.DB.prepare(
    "SELECT * FROM clients WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<ClientRow>();

  if (!client) {
    throw ApiError.notFound();
  }

  return jsonOk(client);
}

export async function createClient(
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

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const client: ClientRow = {
    id,
    full_name: fullName.trim(),
    preferred_name: optionalString(body, "preferred_name"),
    phone: optionalString(body, "phone"),
    email: optionalString(body, "email"),
    address_id: optionalString(body, "address_id"),
    emergency_contact_name: optionalString(body, "emergency_contact_name"),
    emergency_contact_phone: optionalString(body, "emergency_contact_phone"),
    notes: optionalString(body, "notes"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO clients (
      id, full_name, preferred_name, phone, email, address_id,
      emergency_contact_name, emergency_contact_phone, notes,
      archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12)`,
  )
    .bind(
      client.id,
      client.full_name,
      client.preferred_name,
      client.phone,
      client.email,
      client.address_id,
      client.emergency_contact_name,
      client.emergency_contact_phone,
      client.notes,
      client.archived_at,
      client.created_at,
      client.updated_at,
    )
    .run();

  return jsonOk(client, 201);
}

export async function updateClient(
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

  const existing = await env.DB.prepare(
    "SELECT * FROM clients WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<ClientRow>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    `UPDATE clients SET
      full_name = ?1,
      preferred_name = ?2,
      phone = ?3,
      email = ?4,
      address_id = ?5,
      emergency_contact_name = ?6,
      emergency_contact_phone = ?7,
      notes = ?8,
      updated_at = ?9
    WHERE id = ?10`,
  )
    .bind(
      fullName.trim(),
      optionalString(body, "preferred_name"),
      optionalString(body, "phone"),
      optionalString(body, "email"),
      optionalString(body, "address_id"),
      optionalString(body, "emergency_contact_name"),
      optionalString(body, "emergency_contact_phone"),
      optionalString(body, "notes"),
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM clients WHERE id = ?1",
  )
    .bind(params.id)
    .first<ClientRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteClient(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM clients WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    "UPDATE clients SET archived_at = ?1, updated_at = ?2 WHERE id = ?3",
  )
    .bind(now, now, params.id)
    .run();

  return jsonOk({ deleted: true });
}
