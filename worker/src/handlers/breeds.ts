import type { Env } from "../index";
import { jsonOk } from "../response";

interface BreedRow {
  breed_id: string;
  breed_name: string;
}

export async function listBreeds(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT breed_id, breed_name FROM breeds ORDER BY breed_name ASC",
  ).all<BreedRow>();
  return jsonOk(results ?? []);
}
