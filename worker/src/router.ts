import type { Env } from "./index";
import { jsonOk, jsonError } from "./response";
import { requireBearerToken } from "./middleware/auth";
import { login, logout, me, validateSessionToken } from "./handlers/auth";
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
  uploadDogAvatar,
  getDogAvatar,
  uploadDogNosePrint,
  getDogNosePrint,
  uploadDogWalkingGearPhoto,
  getDogWalkingGearPhoto,
} from "./handlers/dogs";
import {
  listWalks,
  getWalk,
  createWalk,
  updateWalk,
  deleteWalk,
} from "./handlers/walks";
import {
  listWalkers,
  getWalker,
  createWalker,
  updateWalker,
  deleteWalker,
} from "./handlers/walkers";
import {
  listInvoiceHeaders,
  getInvoiceHeader,
  createInvoiceHeader,
  updateInvoiceHeader,
  deleteInvoiceHeader,
} from "./handlers/invoice_headers";
import {
  listInvoiceLines,
  getInvoiceLine,
  createInvoiceLine,
  updateInvoiceLine,
  deleteInvoiceLine,
} from "./handlers/invoice_lines";
import {
  listBehaviorSnapshots,
  createBehaviorSnapshot,
} from "./handlers/behavior_snapshots";
import {
  listVaccinations,
  createVaccination,
} from "./handlers/vaccinations";
import { createAttachment, getAttachmentById } from "./handlers/attachments";
import { listBreeds } from "./handlers/breeds";
import { listVetPractices } from "./handlers/vet_practices";
import { getDashboard } from "./handlers/dashboard";
import { getWeatherToday } from "./handlers/weather";

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

  // Health endpoints are public — no auth required
  if (pathname === "/health" || pathname === "/api/v1/health") {
    return handleHealth();
  }

  // Auth endpoints are public — they are the authentication mechanism
  if (pathname === "/api/v1/auth/login") {
    if (method === "POST") return login(request, env);
    return methodNotAllowed(["POST"]);
  }

  if (pathname === "/api/v1/auth/logout") {
    if (method === "POST") return logout(request, env);
    return methodNotAllowed(["POST"]);
  }

  if (pathname === "/api/v1/auth/me") {
    if (method === "GET") return me(request, env);
    return methodNotAllowed(["GET"]);
  }

  // All routes below require authentication.
  // Accept either the env API_BEARER_TOKEN (dev/service access) or a valid user session token.
  const authHeader = request.headers.get("Authorization");
  const token = authHeader?.startsWith("Bearer ")
    ? authHeader.slice(7).trim()
    : "";

  const envTokenValid =
    !!env.API_BEARER_TOKEN &&
    token === env.API_BEARER_TOKEN;

  if (!envTokenValid) {
    // Try user session token
    const sessionUser = token
      ? await validateSessionToken(token, env)
      : null;
    if (!sessionUser) {
      return jsonError("Missing or invalid bearer token", "unauthorized", 401);
    }
  }

  if (pathname === "/api/v1/dashboard") {
    if (method === "GET") return getDashboard(request, env);
    return methodNotAllowed(["GET"]);
  }

  if (pathname === "/api/v1/weather/today") {
    if (method === "GET") return getWeatherToday(request, env);
    return methodNotAllowed(["GET"]);
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

  if (pathname === "/api/v1/breeds") {
    if (method === "GET") return listBreeds(request, env);
    return methodNotAllowed(["GET"]);
  }

  if (pathname === "/api/v1/vet-practices") {
    if (method === "GET") return listVetPractices(request, env);
    return methodNotAllowed(["GET"]);
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

  const dogAvatarMatch = pathname.match(/^\/api\/v1\/dogs\/([^/]+)\/avatar$/);
  if (dogAvatarMatch) {
    const params = { id: dogAvatarMatch[1] };
    if (method === "GET") return getDogAvatar(request, env, params);
    if (method === "POST") return uploadDogAvatar(request, env, params);
    return methodNotAllowed(["GET", "POST"]);
  }


  const dogNosePrintMatch = pathname.match(/^\/api\/v1\/dogs\/([^/]+)\/nose-print$/);
  if (dogNosePrintMatch) {
    const params = { id: dogNosePrintMatch[1] };
    if (method === "GET") return getDogNosePrint(request, env, params);
    if (method === "POST") return uploadDogNosePrint(request, env, params);
    return methodNotAllowed(["GET", "POST"]);
  }

  const dogWalkingGearMatch = pathname.match(/^\/api\/v1\/dogs\/([^/]+)\/walking-gear$/);
  if (dogWalkingGearMatch) {
    const params = { id: dogWalkingGearMatch[1] };
    if (method === "GET") return getDogWalkingGearPhoto(request, env, params);
    if (method === "POST") return uploadDogWalkingGearPhoto(request, env, params);
    return methodNotAllowed(["GET", "POST"]);
  }

  const behaviorSnapshotMatch = pathname.match(
    /^\/api\/v1\/dogs\/([^/]+)\/behavior-snapshots$/,
  );
  if (behaviorSnapshotMatch) {
    const params = { dogId: behaviorSnapshotMatch[1] };
    if (method === "GET") return listBehaviorSnapshots(request, env, params);
    if (method === "POST") return createBehaviorSnapshot(request, env, params);
    return methodNotAllowed(["GET", "POST"]);
  }

  const vaccinationMatch = pathname.match(
    /^\/api\/v1\/dogs\/([^/]+)\/vaccinations$/,
  );
  if (vaccinationMatch) {
    const params = { dogId: vaccinationMatch[1] };
    if (method === "GET") return listVaccinations(request, env, params);
    if (method === "POST") return createVaccination(request, env, params);
    return methodNotAllowed(["GET", "POST"]);
  }

  if (pathname === "/api/v1/walks") {
    if (method === "GET") return listWalks(request, env);
    if (method === "POST") return createWalk(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const walkMatch = pathname.match(/^\/api\/v1\/walks\/([^/]+)$/);
  if (walkMatch) {
    const params = { id: walkMatch[1] };
    if (method === "GET") return getWalk(request, env, params);
    if (method === "PUT") return updateWalk(request, env, params);
    if (method === "DELETE") return deleteWalk(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  if (pathname === "/api/v1/walkers") {
    if (method === "GET") return listWalkers(request, env);
    if (method === "POST") return createWalker(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const walkerMatch = pathname.match(/^\/api\/v1\/walkers\/([^/]+)$/);
  if (walkerMatch) {
    const params = { id: walkerMatch[1] };
    if (method === "GET") return getWalker(request, env, params);
    if (method === "PUT") return updateWalker(request, env, params);
    if (method === "DELETE") return deleteWalker(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  if (pathname === "/api/v1/invoice-headers" || pathname === "/api/v1/invoices") {
    if (method === "GET") return listInvoiceHeaders(request, env);
    if (method === "POST") return createInvoiceHeader(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const invoiceHeaderMatch = pathname.match(/^\/api\/v1\/(?:invoice-headers|invoices)\/([^/]+)$/);
  if (invoiceHeaderMatch) {
    const params = { id: invoiceHeaderMatch[1] };
    if (method === "GET") return getInvoiceHeader(request, env, params);
    if (method === "PUT") return updateInvoiceHeader(request, env, params);
    if (method === "DELETE") return deleteInvoiceHeader(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  if (pathname === "/api/v1/invoice-lines") {
    if (method === "GET") return listInvoiceLines(request, env);
    if (method === "POST") return createInvoiceLine(request, env);
    return methodNotAllowed(["GET", "POST"]);
  }

  const invoiceLineMatch = pathname.match(/^\/api\/v1\/invoice-lines\/([^/]+)$/);
  if (invoiceLineMatch) {
    const params = { id: invoiceLineMatch[1] };
    if (method === "GET") return getInvoiceLine(request, env, params);
    if (method === "PUT") return updateInvoiceLine(request, env, params);
    if (method === "DELETE") return deleteInvoiceLine(request, env, params);
    return methodNotAllowed(["GET", "PUT", "DELETE"]);
  }

  if (pathname === "/api/v1/attachments") {
    if (method === "POST") return createAttachment(request, env);
    return methodNotAllowed(["POST"]);
  }

  const attachmentMatch = pathname.match(/^\/api\/v1\/attachments\/([^/]+)$/);
  if (attachmentMatch) {
    const params = { id: attachmentMatch[1] };
    if (method === "GET") return getAttachmentById(request, env, params);
    return methodNotAllowed(["GET"]);
  }

  return jsonError("Not found", "not_found", 404);
}

