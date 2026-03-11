import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";
import { putAttachment, getAttachment } from "../storage";

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
  breed_id: string | null;
  sex: string | null;
  neutered: number;
  date_of_birth: string | null;
  colour: string | null;
  microchip_number: string | null;
  veterinary_practice: string | null;
  medical_notes: string | null;
  behavioural_notes: string | null;
  feeding_notes: string | null;
  avatar_object_key: string | null;
  profile_photo_object_key: string | null;
  nose_print_object_key: string | null;
  allergies: number;
  allergies_notes: string | null;
  medication: number;
  medication_notes: string | null;
  vet_practice_id: string | null;
  energy_level: string | null;
  leash_manners: string | null;
  recall_rating: string | null;
  aggressive: number;
  muzzle_required: number;
  special_commands: string | null;
  walking_gear_object_key: string | null;
  gear_location: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
}

interface DogWithBreedRow extends DogRow {
  breed_name: string | null;
  vet_practice_name: string | null;
}

export async function listDogs(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    `SELECT dogs.*, breeds.breed_name, veterinary_practices.name AS vet_practice_name
     FROM dogs
     LEFT JOIN breeds ON dogs.breed_id = breeds.breed_id
     LEFT JOIN veterinary_practices ON dogs.vet_practice_id = veterinary_practices.id
     WHERE dogs.archived_at IS NULL
     ORDER BY dogs.name ASC`,
  ).all<DogWithBreedRow>();
  return jsonOk(results ?? []);
}

export async function getDog(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const dog = await env.DB.prepare(
    `SELECT dogs.*, breeds.breed_name, veterinary_practices.name AS vet_practice_name
     FROM dogs
     LEFT JOIN breeds ON dogs.breed_id = breeds.breed_id
     LEFT JOIN veterinary_practices ON dogs.vet_practice_id = veterinary_practices.id
     WHERE dogs.id = ?1 AND dogs.archived_at IS NULL`,
  )
    .bind(params.id)
    .first<DogWithBreedRow>();

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
    breed_id: optionalString(body, "breed_id"),
    sex: typeof sexValue === "string" ? sexValue : null,
    neutered: parseNeutered(body["neutered"]),
    date_of_birth: optionalString(body, "date_of_birth"),
    colour: optionalString(body, "colour"),
    microchip_number: optionalString(body, "microchip_number"),
    veterinary_practice: optionalString(body, "veterinary_practice"),
    medical_notes: optionalString(body, "medical_notes"),
    behavioural_notes: optionalString(body, "behavioural_notes"),
    feeding_notes: optionalString(body, "feeding_notes"),
    avatar_object_key: null,
    profile_photo_object_key: null,
    nose_print_object_key: null,
    allergies: parseNeutered(body["allergies"]),
    allergies_notes: optionalString(body, "allergies_notes"),
    medication: parseNeutered(body["medication"]),
    medication_notes: optionalString(body, "medication_notes"),
    vet_practice_id: optionalString(body, "vet_practice_id"),
    energy_level: optionalString(body, "energy_level"),
    leash_manners: optionalString(body, "leash_manners"),
    recall_rating: optionalString(body, "recall_rating"),
    aggressive: parseNeutered(body["aggressive"]),
    muzzle_required: parseNeutered(body["muzzle_required"]),
    special_commands: optionalString(body, "special_commands"),
    walking_gear_object_key: null,
    gear_location: optionalString(body, "gear_location"),
    archived_at: null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO dogs (
      id, client_id, name, breed, breed_id, sex, neutered, date_of_birth, colour,
      microchip_number, veterinary_practice, medical_notes, behavioural_notes,
      feeding_notes, avatar_object_key, profile_photo_object_key, nose_print_object_key,
      allergies, allergies_notes, medication, medication_notes, vet_practice_id,
      energy_level, leash_manners, recall_rating, aggressive, muzzle_required,
      special_commands, walking_gear_object_key, gear_location,
      archived_at, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14, ?15, ?16, ?17, ?18, ?19, ?20, ?21, ?22, ?23, ?24, ?25, ?26, ?27, ?28, ?29, ?30, ?31, ?32, ?33)`,
  )
    .bind(
      dog.id,
      dog.client_id,
      dog.name,
      dog.breed,
      dog.breed_id,
      dog.sex,
      dog.neutered,
      dog.date_of_birth,
      dog.colour,
      dog.microchip_number,
      dog.veterinary_practice,
      dog.medical_notes,
      dog.behavioural_notes,
      dog.feeding_notes,
      dog.avatar_object_key,
      dog.profile_photo_object_key,
      dog.nose_print_object_key,
      dog.allergies,
      dog.allergies_notes,
      dog.medication,
      dog.medication_notes,
      dog.vet_practice_id,
      dog.energy_level,
      dog.leash_manners,
      dog.recall_rating,
      dog.aggressive,
      dog.muzzle_required,
      dog.special_commands,
      dog.walking_gear_object_key,
      dog.gear_location,
      dog.archived_at,
      dog.created_at,
      dog.updated_at,
    )
    .run();

  // Re-fetch with breed_name join
  const created = await env.DB.prepare(
    `SELECT dogs.*, breeds.breed_name, veterinary_practices.name AS vet_practice_name
     FROM dogs
     LEFT JOIN breeds ON dogs.breed_id = breeds.breed_id
     LEFT JOIN veterinary_practices ON dogs.vet_practice_id = veterinary_practices.id
     WHERE dogs.id = ?1`,
  )
    .bind(id)
    .first<DogWithBreedRow>();

  return jsonOk(created ?? dog, 201);
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
      breed_id = ?4,
      sex = ?5,
      neutered = ?6,
      date_of_birth = ?7,
      colour = ?8,
      microchip_number = ?9,
      veterinary_practice = ?10,
      medical_notes = ?11,
      behavioural_notes = ?12,
      feeding_notes = ?13,
      allergies = ?14,
      allergies_notes = ?15,
      medication = ?16,
      medication_notes = ?17,
      vet_practice_id = ?18,
      energy_level = ?19,
      leash_manners = ?20,
      recall_rating = ?21,
      aggressive = ?22,
      muzzle_required = ?23,
      special_commands = ?24,
      gear_location = ?25,
      updated_at = ?26
    WHERE id = ?27 AND archived_at IS NULL`,
  )
    .bind(
      clientId,
      name.trim(),
      optionalString(body, "breed"),
      optionalString(body, "breed_id"),
      typeof sexValue === "string" ? sexValue : null,
      parseNeutered(body["neutered"]),
      optionalString(body, "date_of_birth"),
      optionalString(body, "colour"),
      optionalString(body, "microchip_number"),
      optionalString(body, "veterinary_practice"),
      optionalString(body, "medical_notes"),
      optionalString(body, "behavioural_notes"),
      optionalString(body, "feeding_notes"),
      parseNeutered(body["allergies"]),
      optionalString(body, "allergies_notes"),
      parseNeutered(body["medication"]),
      optionalString(body, "medication_notes"),
      optionalString(body, "vet_practice_id"),
      optionalString(body, "energy_level"),
      optionalString(body, "leash_manners"),
      optionalString(body, "recall_rating"),
      parseNeutered(body["aggressive"]),
      parseNeutered(body["muzzle_required"]),
      optionalString(body, "special_commands"),
      optionalString(body, "gear_location"),
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    `SELECT dogs.*, breeds.breed_name, veterinary_practices.name AS vet_practice_name
     FROM dogs
     LEFT JOIN breeds ON dogs.breed_id = breeds.breed_id
     LEFT JOIN veterinary_practices ON dogs.vet_practice_id = veterinary_practices.id
     WHERE dogs.id = ?1 AND dogs.archived_at IS NULL`,
  )
    .bind(params.id)
    .first<DogWithBreedRow>();

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

export async function uploadDogAvatar(
  request: Request,
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

  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonError(
      "Request must be multipart/form-data with an avatar_file field",
      "invalid_request",
      400,
    );
  }

  const fileEntry = formData.get("avatar_file") as unknown;
  if (
    !fileEntry ||
    typeof fileEntry === "string" ||
    !(fileEntry instanceof Blob)
  ) {
    return jsonError("avatar_file field is required", "invalid_request", 400);
  }
  const file = fileEntry as File;

  const objectKey = `dogs/${params.id}/avatar/original`;
  const mimeType = file.type || "application/octet-stream";
  const fileBytes = await file.arrayBuffer();

  await putAttachment(env, objectKey, fileBytes, mimeType);

  const now = new Date().toISOString();
  await env.DB.prepare(
    "UPDATE dogs SET avatar_object_key = ?1, updated_at = ?2 WHERE id = ?3 AND archived_at IS NULL",
  )
    .bind(objectKey, now, params.id)
    .run();

  const updated = await env.DB.prepare(
    `SELECT dogs.*, breeds.breed_name, veterinary_practices.name AS vet_practice_name
     FROM dogs
     LEFT JOIN breeds ON dogs.breed_id = breeds.breed_id
     LEFT JOIN veterinary_practices ON dogs.vet_practice_id = veterinary_practices.id
     WHERE dogs.id = ?1 AND dogs.archived_at IS NULL`,
  )
    .bind(params.id)
    .first<DogWithBreedRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function getDogAvatar(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const dog = await env.DB.prepare(
    "SELECT avatar_object_key FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.id)
    .first<{ avatar_object_key: string | null }>();

  if (!dog) {
    throw ApiError.notFound();
  }

  if (!dog.avatar_object_key) {
    return jsonError("No avatar uploaded", "not_found", 404);
  }

  const r2Object = await getAttachment(env, dog.avatar_object_key);

  if (!r2Object) {
    return jsonError("Avatar file not found in storage", "not_found", 404);
  }

  const headers = new Headers();
  headers.set(
    "Content-Type",
    r2Object.httpMetadata?.contentType ?? "application/octet-stream",
  );

  return new Response(r2Object.body, { headers });
}
