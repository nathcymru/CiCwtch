import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

interface VaccinationRow {
  id: string;
  dog_id: string;
  vaccination_name: string;
  date_administered: string;
  expiration_date: string | null;
  document_object_key: string | null;
  created_at: string;
  updated_at: string;
}

export async function listVaccinations(
  _request: Request,
  env: Env,
  params: { dogId: string },
): Promise<Response> {
  const dog = await env.DB.prepare(
    "SELECT id FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.dogId)
    .first<{ id: string }>();

  if (!dog) {
    throw ApiError.notFound();
  }

  const { results } = await env.DB.prepare(
    `SELECT * FROM vaccinations
     WHERE dog_id = ?1
     ORDER BY date_administered DESC`,
  )
    .bind(params.dogId)
    .all<VaccinationRow>();

  return jsonOk(results ?? []);
}

export async function createVaccination(
  request: Request,
  env: Env,
  params: { dogId: string },
): Promise<Response> {
  const dog = await env.DB.prepare(
    "SELECT id FROM dogs WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(params.dogId)
    .first<{ id: string }>();

  if (!dog) {
    throw ApiError.notFound();
  }

  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const vaccinationName = body["vaccination_name"];
  if (typeof vaccinationName !== "string" || vaccinationName.trim() === "") {
    return jsonError(
      "vaccination_name is required",
      "invalid_request",
      400,
    );
  }

  const dateAdministered = body["date_administered"];
  if (
    typeof dateAdministered !== "string" ||
    dateAdministered.trim() === ""
  ) {
    return jsonError(
      "date_administered is required",
      "invalid_request",
      400,
    );
  }

  const expirationDate =
    typeof body["expiration_date"] === "string" &&
    body["expiration_date"].trim() !== ""
      ? body["expiration_date"]
      : null;

  const documentObjectKey =
    typeof body["document_object_key"] === "string" &&
    body["document_object_key"].trim() !== ""
      ? body["document_object_key"]
      : null;

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const vaccination: VaccinationRow = {
    id,
    dog_id: params.dogId,
    vaccination_name: vaccinationName.trim(),
    date_administered: dateAdministered.trim(),
    expiration_date: expirationDate as string | null,
    document_object_key: documentObjectKey as string | null,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO vaccinations (
      id, dog_id, vaccination_name, date_administered,
      expiration_date, document_object_key, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)`,
  )
    .bind(
      vaccination.id,
      vaccination.dog_id,
      vaccination.vaccination_name,
      vaccination.date_administered,
      vaccination.expiration_date,
      vaccination.document_object_key,
      vaccination.created_at,
      vaccination.updated_at,
    )
    .run();

  return jsonOk(vaccination, 201);
}
