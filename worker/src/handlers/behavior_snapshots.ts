import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

interface BehaviorSnapshotRow {
  id: string;
  dog_id: string;
  created_at: string;
  recall_rating: number | null;
  leash_manners_rating: number | null;
  energy_level_rating: number | null;
  behavior_tags_json: string | null;
  notes: string | null;
}

function isValidRating(value: unknown): boolean {
  if (value === null || value === undefined) return true;
  if (typeof value !== "number") return false;
  return Number.isInteger(value) && value >= 1 && value <= 5;
}

export async function listBehaviorSnapshots(
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
    `SELECT * FROM behavior_snapshots
     WHERE dog_id = ?1
     ORDER BY created_at DESC`,
  )
    .bind(params.dogId)
    .all<BehaviorSnapshotRow>();

  return jsonOk(results ?? []);
}

export async function createBehaviorSnapshot(
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

  const recallRating = body["recall_rating"] ?? null;
  const leashMannersRating = body["leash_manners_rating"] ?? null;
  const energyLevelRating = body["energy_level_rating"] ?? null;

  if (!isValidRating(recallRating)) {
    return jsonError(
      "recall_rating must be an integer between 1 and 5",
      "invalid_request",
      400,
    );
  }

  if (!isValidRating(leashMannersRating)) {
    return jsonError(
      "leash_manners_rating must be an integer between 1 and 5",
      "invalid_request",
      400,
    );
  }

  if (!isValidRating(energyLevelRating)) {
    return jsonError(
      "energy_level_rating must be an integer between 1 and 5",
      "invalid_request",
      400,
    );
  }

  let behaviorTagsJson: string | null = null;
  if (body["behavior_tags_json"] !== undefined && body["behavior_tags_json"] !== null) {
    if (typeof body["behavior_tags_json"] === "string") {
      behaviorTagsJson = body["behavior_tags_json"];
    } else if (Array.isArray(body["behavior_tags_json"])) {
      behaviorTagsJson = JSON.stringify(body["behavior_tags_json"]);
    } else {
      return jsonError(
        "behavior_tags_json must be a JSON string or an array",
        "invalid_request",
        400,
      );
    }
  }

  const notes =
    typeof body["notes"] === "string" ? body["notes"] : null;

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const snapshot: BehaviorSnapshotRow = {
    id,
    dog_id: params.dogId,
    created_at: now,
    recall_rating: (recallRating as number | null) ?? null,
    leash_manners_rating: (leashMannersRating as number | null) ?? null,
    energy_level_rating: (energyLevelRating as number | null) ?? null,
    behavior_tags_json: behaviorTagsJson,
    notes,
  };

  await env.DB.prepare(
    `INSERT INTO behavior_snapshots (
      id, dog_id, created_at, recall_rating, leash_manners_rating,
      energy_level_rating, behavior_tags_json, notes
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)`,
  )
    .bind(
      snapshot.id,
      snapshot.dog_id,
      snapshot.created_at,
      snapshot.recall_rating,
      snapshot.leash_manners_rating,
      snapshot.energy_level_rating,
      snapshot.behavior_tags_json,
      snapshot.notes,
    )
    .run();

  return jsonOk(snapshot, 201);
}
