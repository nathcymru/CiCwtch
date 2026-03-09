import { jsonError } from "../response";

const UNAUTHORIZED_MESSAGE = "Missing or invalid bearer token";
const UNAUTHORIZED_CODE = "unauthorized";

/**
 * Validate a bearer token from the Authorization header.
 *
 * Returns null when the token is valid, or a 401 JSON Response when
 * the token is missing, malformed, the configured secret is missing,
 * or the supplied value does not match the expected token.
 */
export function requireBearerToken(
  request: Request,
  expectedToken: string | undefined,
): Response | null {
  const header = request.headers.get("Authorization");

  if (!expectedToken || !header || !header.startsWith("Bearer ")) {
    return jsonError(UNAUTHORIZED_MESSAGE, UNAUTHORIZED_CODE, 401);
  }

  const token = header.slice(7).trim();

  if (!token || token !== expectedToken) {
    return jsonError(UNAUTHORIZED_MESSAGE, UNAUTHORIZED_CODE, 401);
  }

  return null;
}
