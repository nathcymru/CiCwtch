import type { Env } from "./index";
import { jsonOk, jsonError } from "./response";
import {
  listClients,
  getClient,
  createClient,
  updateClient,
  deleteClient,
} from "./handlers/clients";

const HEALTH_RESPONSE = { status: "ok", service: "cicwtch-api" };

function handleHealth(): Response {
  return jsonOk(HEALTH_RESPONSE);
}

function methodNotAllowed(allowedMethods: string[]): Response {
  return new Response(
    JSON.stringify({
      error: {
        message: "Method not allowed",
        type: "method_not_allowed",
      },
    }),
    {
      status: 405,
      headers: {
        "Content-Type": "application/json",
        Allow: allowedMethods.join(", "),
      },
    },
  );
}

export async function route(
  request: Request,
  env: Env,
): Promise<Response> {
  const url = new URL(request.url);
  const { pathname } = url;
  const method = request.method;

  if (pathname === "/health" || pathname === "/api/v1/health") {
    return handleHealth();
  }

  if (pathname === "/api/v1/clients") {
    if (method === "GET") return listClients(request, env);
    if (method === "POST") return createClient(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const clientMatch = pathname.match(/^\/api\/v1\/clients\/([^/]+)$/);
  if (clientMatch) {
    const params = { id: clientMatch[1] };
    if (method === "GET") return getClient(request, env, params);
    if (method === "PUT") return updateClient(request, env, params);
    if (method === "DELETE") return deleteClient(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  return jsonError("Not found", "not_found", 404);
}
