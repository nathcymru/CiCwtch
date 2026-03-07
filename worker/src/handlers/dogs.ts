import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

function parseNeutered(value: unknown): number {
  if (typeof value === "boolean") return value ? 1 : 0;
  if (value === 1 || value === 0) return value;
  return 0;
}

const VALID_SEX_VALUES = ["male", "female", "unknown"] as const;

interface DogRow {
  id: string;
  client_id: string;
  name: string;
  breed: string | null;
  sex: string | null;
  neutered: number;
  date_of_birth: string | null;
  colour: string | null;
  microchip_number: string | null;
  veterinary_practice: string | null;
  medical_notes: string | null;
  behavioural_notes: string | null;
  feeding_notes: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

export async function listDogs(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM dogs WHERE archived_at IS NULL ORDER BY name ASC",
  ).all<DogRow>();
  return jsonOk(results ?? []);
}

export async function getDog(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const dog = await env.DB.prepare(
    "SELECT * FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<DogRow>();

  if (!dog) {
    throw ApiError.notFound();
  }

  return jsonOk(dog);
}

export async function createDog(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const name = body["name"];
  if (typeof name !== "string" || name.trim() === "") {
    return jsonError("name is required", "invalid_request", 400);
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

  const sexValue = body["sex"];
  if (
    sexValue !== undefined &&
    sexValue !== null &&
    !VALID_SEX_VALUES.includes(sexValue as (typeof VALID_SEX_VALUES)[number])
  ) {
    return jsonError(
      "sex must be 'male', 'female', or 'unknown'",
      "invalid_request",
      400,
    );
  }

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const dog: DogRow = {
    id,
    client_id: clientId.trim(),
    name: name.trim(),
    breed: optionalString(body, "breed"),
    sex: typeof sexValue === "string" ? sexValue : null,
    neutered: parseNeutered(body["neutered"]),
    date_of_birth: optionalString(body, "date_of_birth"),
    colour: optionalString(body, "colour"),
    microchip_number: optionalString(body, "microchip_number"),
    veterinary_practice: optionalString(body, "veterinary_practice"),
    medical_notes: optionalString(body, "medical_notes"),
    behavioural_notes: optionalString(body, "behavioural_notes"),
    feeding_notes: optionalString(body, "feeding_notes"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO dogs (
      id, client_id, name, breed, sex, neutered, date_of_birth, colour,
      microchip_number, veterinary_practice, medical_notes, behavioural_notes,
      feeding_notes, archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14, ?15, ?16)`,
  )
    .bind(
      dog.id,
      dog.client_id,
      dog.name,
      dog.breed,
      dog.sex,
      dog.neutered,
      dog.date_of_birth,
      dog.colour,
      dog.microchip_number,
      dog.veterinary_practice,
      dog.medical_notes,
      dog.behavioural_notes,
      dog.feeding_notes,
      dog.archived_at,
      dog.created_at,
      dog.updated_at,
    )
    .run();

  return jsonOk(dog, 201);
}

export async function updateDog(
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

  const name = body["name"];
  if (typeof name !== "string" || name.trim() === "") {
    return jsonError("name is required", "invalid_request", 400);
  }

  const existing = await env.DB.prepare(
    "SELECT * FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<DogRow>();

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

  const sexValue = body["sex"];
  if (
    sexValue !== undefined &&
    sexValue !== null &&
    !VALID_SEX_VALUES.includes(sexValue as (typeof VALID_SEX_VALUES)[number])
  ) {
    return jsonError(
      "sex must be 'male', 'female', or 'unknown'",
      "invalid_request",
      400,
    );
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    `UPDATE dogs SET
      client_id = ?1,
      name = ?2,
      breed = ?3,
      sex = ?4,
      neutered = ?5,
      date_of_birth = ?6,
      colour = ?7,
      microchip_number = ?8,
      veterinary_practice = ?9,
      medical_notes = ?10,
      behavioural_notes = ?11,
      feeding_notes = ?12,
      updated_at = ?13
    WHERE id = ?14 AND archived_at IS NULL`,
  )
    .bind(
      clientId,
      name.trim(),
      optionalString(body, "breed"),
      typeof sexValue === "string" ? sexValue : null,
      parseNeutered(body["neutered"]),
      optionalString(body, "date_of_birth"),
      optionalString(body, "colour"),
      optionalString(body, "microchip_number"),
      optionalString(body, "veterinary_practice"),
      optionalString(body, "medical_notes"),
      optionalString(body, "behavioural_notes"),
      optionalString(body, "feeding_notes"),
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<DogRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteDog(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  const now = new Date().toISOString();

  await env.DB.prepare(
    "UPDATE dogs SET archived_at = ?1, updated_at = ?2 WHERE id = ?3 AND archived_at IS NULL",
  )
    .bind(now, now, params.id)
    .run();

  return jsonOk({ deleted: true });
}
