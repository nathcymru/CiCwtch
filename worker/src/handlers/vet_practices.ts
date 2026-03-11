import type { Env } from "../index";
import { jsonOk } from "../response";

interface VetPracticeRow {
  id: string;
  name: string;
  phone: string | null;
  email: string | null;
  address: string | null;
  created_at: string;
  updated_at: string;
}

export async function listVetPractices(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM veterinary_practices ORDER BY name ASC",
  ).all<VetPracticeRow>();
  return jsonOk(results ?? []);
}
