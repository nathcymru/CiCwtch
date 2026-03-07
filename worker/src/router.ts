import type { Env } from "./index";
import { jsonOk, jsonError } from "./response";

const HEALTH_RESPONSE = { status: "ok", service: "cicwtch-api" };

function handleHealth(): Response {
  return jsonOk(HEALTH_RESPONSE);
}

export async function route(
  request: Request,
  // env is passed through so future handlers can access env.DB
  env: Env,
): Promise<Response> {
  void env;

  const url = new URL(request.url);

  if (
    url.pathname === "/health" ||
    url.pathname === "/api/v1/health"
  ) {
    return handleHealth();
  }

  return jsonError("Not found", "not_found", 404);
}
