import type { Env } from "./index";
import { jsonOk, jsonError } from "./response";
import {
  listClients,
  getClient,
  createClient,
  updateClient,
  deleteClient,
} from "./handlers/clients";
import {
  listDogs,
  getDog,
  createDog,
  updateDog,
  deleteDog,
} from "./handlers/dogs";

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

  if (pathname === "/api/v1/dogs") {
    if (method === "GET") return listDogs(request, env);
    if (method === "POST") return createDog(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const dogMatch = pathname.match(/^\/api\/v1\/dogs\/([^/]+)$/);
  if (dogMatch) {
    const params = { id: dogMatch[1] };
    if (method === "GET") return getDog(request, env, params);
    if (method === "PUT") return updateDog(request, env, params);
    if (method === "DELETE") return deleteDog(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  return jsonError("Not found", "not_found", 404);
}

