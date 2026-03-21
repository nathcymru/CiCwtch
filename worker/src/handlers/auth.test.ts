import { describe, it, expect } from "vitest";
import { hashPassword, verifyPassword } from "./auth";
import { route } from "../router";
import type { Env } from "../index";

// ---------------------------------------------------------------------------
// Password hashing tests
// ---------------------------------------------------------------------------

describe("hashPassword", () => {
  it("produces a pbkdf2:sha256 prefixed hash", async () => {
    const hash = await hashPassword("hunter2");
    expect(hash).toMatch(/^pbkdf2:sha256:100000:/);
  });

  it("produces a different hash each call (salted)", async () => {
    const h1 = await hashPassword("same-password");
    const h2 = await hashPassword("same-password");
    expect(h1).not.toBe(h2);
  });
});

describe("verifyPassword", () => {
  it("returns true for matching password", async () => {
    const hash = await hashPassword("correct-horse");
    expect(await verifyPassword("correct-horse", hash)).toBe(true);
  });

  it("returns false for wrong password", async () => {
    const hash = await hashPassword("correct-horse");
    expect(await verifyPassword("wrong-horse", hash)).toBe(false);
  });

  it("returns false for malformed hash", async () => {
    expect(await verifyPassword("anything", "not-a-valid-hash")).toBe(false);
  });

  it("returns false for empty hash", async () => {
    expect(await verifyPassword("password", "")).toBe(false);
  });
});

// ---------------------------------------------------------------------------
// Auth route tests via router
// ---------------------------------------------------------------------------

interface UserRecord {
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

interface SessionRecord {
  id: string;
  user_id: string;
  token: string;
  expires_at: string;
  created_at: string;
}

async function buildEnvWithUser(overrides: Partial<UserRecord> = {}): Promise<{
  env: Env;
  sessions: SessionRecord[];
}> {
  const password = "testpass123";
  const passwordHash = await hashPassword(password);

  const user: UserRecord = {
    id: "user-001",
    organisation_id: "org-001",
    email: "test@example.com",
    password_hash: passwordHash,
    full_name: "Test User",
    phone: null,
    role: "admin",
    is_active: 1,
    password_reset_required: 0,
    archived_at: null,
    ...overrides,
  };

  const sessions: SessionRecord[] = [];

  const env: Env = {
    DB: {
      prepare(sql: string) {
        return {
          bind(...bindArgs: unknown[]) {
            const stmt = this;
            return {
              ...stmt,
              async first<T>() {
                // User lookup by email
                if (sql.includes("FROM users") && sql.includes("email = ?1")) {
                  return user as unknown as T;
                }
                // Session validation: user_sessions JOIN users
                if (
                  sql.includes("FROM user_sessions") &&
                  sql.includes("JOIN users")
                ) {
                  const token = bindArgs[0] as string;
                  const session = sessions.find((s) => s.token === token);
                  if (!session) return null;
                  return {
                    id: user.id,
                    organisation_id: user.organisation_id,
                    email: user.email,
                    full_name: user.full_name,
                    role: user.role,
                  } as unknown as T;
                }
                return null;
              },
              async all<T>() {
                return { results: [] as T[] };
              },
              async run() {
                if (sql.includes("INSERT INTO user_sessions")) {
                  sessions.push({
                    id: bindArgs[0] as string,
                    user_id: bindArgs[1] as string,
                    token: bindArgs[2] as string,
                    expires_at: bindArgs[3] as string,
                    created_at: bindArgs[4] as string,
                  });
                }
                return { success: true };
              },
            };
          },
          async first<T>() { return null as T; },
          async all<T>() { return { results: [] as T[] }; },
          async run() { return { success: true }; },
        };
      },
    } as unknown as D1Database,
    CICWTCH_ATTACHMENTS: {} as R2Bucket,
    API_BEARER_TOKEN: "env-test-token",
  };

  return { env, sessions };
}

describe("POST /api/v1/auth/login — public route", () => {
  it("does not require API_BEARER_TOKEN", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).not.toBe(401);
  });

  it("returns 400 when email is missing", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(400);
  });

  it("returns 400 when password is missing", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(400);
  });

  it("returns 401 for wrong password", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "wrongpass" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(401);
    const body = await res.json() as { error: { code: string } };
    expect(body.error.code).toBe("invalid_credentials");
  });

  it("returns 403 for inactive user", async () => {
    const { env } = await buildEnvWithUser({ is_active: 0 });
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(403);
    const body = await res.json() as { error: { code: string } };
    expect(body.error.code).toBe("account_inactive");
  });

  it("returns 401 for archived user", async () => {
    const { env } = await buildEnvWithUser({ archived_at: "2024-01-01T00:00:00.000Z" });
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(401);
    const body = await res.json() as { error: { code: string } };
    expect(body.error.code).toBe("invalid_credentials");
  });

  it("returns 403 when password reset is required", async () => {
    const { env } = await buildEnvWithUser({ password_reset_required: 1 });
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(403);
    const body = await res.json() as { error: { code: string } };
    expect(body.error.code).toBe("password_reset_required");
  });

  it("returns token and user on successful login", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "test@example.com", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(200);
    const body = await res.json() as {
      token: string;
      expires_at: string;
      user: { id: string; organisation_id: string; email: string; full_name: string; role: string };
    };
    expect(typeof body.token).toBe("string");
    expect(body.user.email).toBe("test@example.com");
    expect(body.user.organisation_id).toBe("org-001");
    expect(body.user.role).toBe("admin");
    expect(body.user).not.toHaveProperty("password_hash");
  });

  it("normalises email to lowercase before lookup", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: "TEST@EXAMPLE.COM", password: "testpass123" }),
    });
    const res = await route(req, env);
    expect(res.status).toBe(200);
  });

  it("returns 405 for GET on /api/v1/auth/login", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/login", {
      method: "GET",
    });
    const res = await route(req, env);
    expect(res.status).toBe(405);
  });
});

describe("GET /api/v1/auth/me", () => {
  it("returns 401 without Authorization header", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/me");
    const res = await route(req, env);
    expect(res.status).toBe(401);
  });

  it("returns 401 with unknown token", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/me", {
      headers: { Authorization: "Bearer unknown-token" },
    });
    const res = await route(req, env);
    expect(res.status).toBe(401);
  });
});

describe("POST /api/v1/auth/logout", () => {
  it("returns 401 without Authorization header", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/logout", {
      method: "POST",
    });
    const res = await route(req, env);
    expect(res.status).toBe(401);
  });

  it("returns 200 with any bearer token (deletes session)", async () => {
    const { env } = await buildEnvWithUser();
    const req = new Request("https://example.com/api/v1/auth/logout", {
      method: "POST",
      headers: { Authorization: "Bearer some-token" },
    });
    const res = await route(req, env);
    expect(res.status).toBe(200);
    const body = await res.json() as { message: string };
    expect(body.message).toBe("Logged out successfully");
  });
});
