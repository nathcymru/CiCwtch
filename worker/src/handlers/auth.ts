import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";

const SESSION_DURATION_DAYS = 30;

// ---------------------------------------------------------------------------
// Password hashing using PBKDF2 via Web Crypto (available in CF Workers)
// Format: pbkdf2:sha256:<iterations>:<base64_salt>:<base64_hash>
// ---------------------------------------------------------------------------

export async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder();
  const salt = crypto.getRandomValues(new Uint8Array(16));

  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    encoder.encode(password),
    "PBKDF2",
    false,
    ["deriveBits"],
  );

  const hashBuffer = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations: 100_000, hash: "SHA-256" },
    keyMaterial,
    256,
  );

  const saltB64 = btoa(String.fromCharCode(...salt));
  const hashB64 = btoa(String.fromCharCode(...new Uint8Array(hashBuffer)));

  return `pbkdf2:sha256:100000:${saltB64}:${hashB64}`;
}

export async function verifyPassword(
  password: string,
  storedHash: string,
): Promise<boolean> {
  const parts = storedHash.split(":");
  if (
    parts.length !== 5 ||
    parts[0] !== "pbkdf2" ||
    parts[1] !== "sha256"
  ) {
    return false;
  }

  const iterations = parseInt(parts[2], 10);
  if (!Number.isFinite(iterations) || iterations <= 0) return false;

  let salt: Uint8Array;
  let expectedHashB64: string;
  try {
    salt = Uint8Array.from(atob(parts[3]), (c) => c.charCodeAt(0));
    expectedHashB64 = parts[4];
  } catch {
    return false;
  }

  const encoder = new TextEncoder();
  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    encoder.encode(password),
    "PBKDF2",
    false,
    ["deriveBits"],
  );

  const hashBuffer = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations, hash: "SHA-256" },
    keyMaterial,
    256,
  );

  const computedHashB64 = btoa(
    String.fromCharCode(...new Uint8Array(hashBuffer)),
  );

  // Constant-time comparison to prevent timing side-channels
  if (computedHashB64.length !== expectedHashB64.length) return false;
  const enc = new TextEncoder();
  const a = enc.encode(computedHashB64);
  const b = enc.encode(expectedHashB64);
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a[i] ^ b[i];
  return diff === 0;
}

// ---------------------------------------------------------------------------
// Session token helpers
// ---------------------------------------------------------------------------

function sessionExpiresAt(): string {
  const d = new Date();
  d.setDate(d.getDate() + SESSION_DURATION_DAYS);
  return d.toISOString();
}

interface UserRow {
  id: string;
  organisation_id: string;
  email: string;
  password_hash: string;
  full_name: string;
  phone: string | null;
  role: string;
  is_active: number;
  password_reset_required: number;
  archived_at: string | null;
}

export interface SessionUser {
  id: string;
  organisation_id: string;
  email: string;
  full_name: string;
  role: string;
}

export async function validateSessionToken(
  token: string,
  env: Env,
): Promise<SessionUser | null> {
  const row = await env.DB.prepare(
    `SELECT u.id, u.organisation_id, u.email, u.full_name, u.role
     FROM user_sessions s
     JOIN users u ON s.user_id = u.id
     WHERE s.token = ?1
       AND s.expires_at > datetime('now')
       AND u.is_active = 1
       AND u.archived_at IS NULL`,
  )
    .bind(token)
    .first<SessionUser>();

  return row ?? null;
}

// ---------------------------------------------------------------------------
// Route handlers
// ---------------------------------------------------------------------------

export async function login(request: Request, env: Env): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const rawEmail = body["email"];
  const rawPassword = body["password"];

  if (typeof rawEmail !== "string" || rawEmail.trim() === "") {
    return jsonError("email is required", "invalid_request", 400);
  }
  if (typeof rawPassword !== "string" || rawPassword === "") {
    return jsonError("password is required", "invalid_request", 400);
  }

  const email = rawEmail.trim().toLowerCase();

  const user = await env.DB.prepare(
    `SELECT id, organisation_id, email, password_hash, full_name, phone, role,
            is_active, password_reset_required, archived_at
     FROM users
     WHERE email = ?1`,
  )
    .bind(email)
    .first<UserRow>();

  // Return a generic error to avoid user enumeration
  if (!user) {
    return jsonError(
      "Invalid email or password",
      "invalid_credentials",
      401,
    );
  }

  if (user.archived_at !== null) {
    return jsonError(
      "Invalid email or password",
      "invalid_credentials",
      401,
    );
  }

  if (user.is_active !== 1) {
    return jsonError(
      "Account is inactive. Contact your administrator.",
      "account_inactive",
      403,
    );
  }

  const passwordValid = await verifyPassword(rawPassword, user.password_hash);
  if (!passwordValid) {
    return jsonError(
      "Invalid email or password",
      "invalid_credentials",
      401,
    );
  }

  if (user.password_reset_required === 1) {
    return jsonError(
      "Password reset required. Contact your administrator to reset your password.",
      "password_reset_required",
      403,
    );
  }

  // Create session
  const sessionId = crypto.randomUUID();
  const token = crypto.randomUUID();
  const expiresAt = sessionExpiresAt();
  const now = new Date().toISOString();

  await env.DB.prepare(
    `INSERT INTO user_sessions (id, user_id, token, expires_at, created_at)
     VALUES (?1, ?2, ?3, ?4, ?5)`,
  )
    .bind(sessionId, user.id, token, expiresAt, now)
    .run();

  // Update last_login_at
  await env.DB.prepare(
    `UPDATE users SET last_login_at = ?1, updated_at = ?2 WHERE id = ?3`,
  )
    .bind(now, now, user.id)
    .run();

  return jsonOk({
    token,
    expires_at: expiresAt,
    user: {
      id: user.id,
      organisation_id: user.organisation_id,
      email: user.email,
      full_name: user.full_name,
      role: user.role,
    },
  });
}

export async function logout(request: Request, env: Env): Promise<Response> {
  const header = request.headers.get("Authorization");
  if (!header?.startsWith("Bearer ")) {
    return jsonError("Missing or invalid bearer token", "unauthorized", 401);
  }
  const token = header.slice(7).trim();

  await env.DB.prepare("DELETE FROM user_sessions WHERE token = ?1")
    .bind(token)
    .run();

  return jsonOk({ message: "Logged out successfully" });
}

export async function me(request: Request, env: Env): Promise<Response> {
  const header = request.headers.get("Authorization");
  if (!header?.startsWith("Bearer ")) {
    return jsonError("Missing or invalid bearer token", "unauthorized", 401);
  }
  const token = header.slice(7).trim();

  const sessionUser = await validateSessionToken(token, env);
  if (!sessionUser) {
    return jsonError("Missing or invalid bearer token", "unauthorized", 401);
  }

  return jsonOk({ user: sessionUser });
}
