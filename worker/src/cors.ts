/**
 * CORS handling for the CiCwtch Workers API.
 *
 * Allows requests from Cloudflare Pages preview deployments,
 * the production Pages domain, and localhost for local development.
 */

const ALLOWED_ORIGIN_PATTERNS: RegExp[] = [
  /^https:\/\/[a-z0-9-]+\.cicwtch\.pages\.dev$/,
  /^https:\/\/cicwtch\.pages\.dev$/,
  /^http:\/\/localhost(:\d+)?$/,
];

const CORS_METHODS = "GET, POST, PUT, DELETE, OPTIONS";
const CORS_HEADERS = "Content-Type, Authorization";
const CORS_MAX_AGE = "86400";

/** Returns the origin if it is allowed, or null otherwise. */
export function getAllowedOrigin(request: Request): string | null {
  const origin = request.headers.get("Origin");
  if (!origin) return null;
  for (const pattern of ALLOWED_ORIGIN_PATTERNS) {
    if (pattern.test(origin)) return origin;
  }
  return null;
}

/** Build a preflight (OPTIONS) response for the given request. */
export function handlePreflight(request: Request): Response {
  const origin = getAllowedOrigin(request);
  if (!origin) {
    return new Response(null, { status: 204 });
  }
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": origin,
      "Access-Control-Allow-Methods": CORS_METHODS,
      "Access-Control-Allow-Headers": CORS_HEADERS,
      "Access-Control-Max-Age": CORS_MAX_AGE,
    },
  });
}

/** Append CORS headers to an existing response (returns a new Response). */
export function withCorsHeaders(
  response: Response,
  request: Request,
): Response {
  const origin = getAllowedOrigin(request);
  if (!origin) return response;

  const newResponse = new Response(response.body, response);
  newResponse.headers.set("Access-Control-Allow-Origin", origin);
  newResponse.headers.set("Access-Control-Allow-Methods", CORS_METHODS);
  newResponse.headers.set("Access-Control-Allow-Headers", CORS_HEADERS);
  return newResponse;
}
