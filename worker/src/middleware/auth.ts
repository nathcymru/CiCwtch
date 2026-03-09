import { jsonError } from "../response";

/**
 * Validate a bearer token from the Authorization header.
 *
 * Returns null when the token is valid, or a 401 JSON Response when
 * the token is missing, malformed, or does not match the expected value.
 *
 * Usage in route handler:
 *   const denied = requireBearerToken(request, env.API_BEARER_TOKEN);
 *   if (denied) return denied;
 */
export function requireBearerToken(
  request: Request,
  expectedToken: string | undefined,
): Response | null {
  if (!expectedToken) {
    return jsonError(
      "Authentication is not configured",
      "auth_not_configured",
      401,
    );
  }

  const header = request.headers.get("Authorization");

  if (!header) {
    return jsonError(
      "Missing Authorization header",
      "unauthorized",
      401,
    );
  }

  if (!header.startsWith("Bearer ")) {
    return jsonError(
      "Invalid Authorization header format",
      "unauthorized",
      401,
    );
  }

  const token = header.slice(7);

  if (token !== expectedToken) {
    return jsonError(
      "Invalid bearer token",
      "unauthorized",
      401,
    );
  }

  return null;
}
