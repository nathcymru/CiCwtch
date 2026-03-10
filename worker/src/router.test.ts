import { describe, it, expect } from "vitest";
import { route } from "./router";
import type { Env } from "./index";

function createEnv(): Env {
  const counts = new Map<string, number>([
    ["SELECT COUNT(*) AS count FROM clients WHERE archived_at IS NULL", 5],
    ["SELECT COUNT(*) AS count FROM dogs WHERE archived_at IS NULL", 12],
    ["SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL", 40],
    ["SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date = date('now')", 3],
    ["SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date > date('now')", 7],
    ["SELECT COUNT(*) AS count FROM walkers WHERE archived_at IS NULL", 4],
    ["SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL", 15],
    ["SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL AND status = 'issued'", 2],
  ]);

  return {
    DB: {
      prepare(sql: string) {
        return {
          first: async <T>() => ({ count: counts.get(sql) ?? 0 } as T),
          all: async <T>() => ({ results: [] as T[] }),
          bind() {
            return this;
          },
          run: async () => ({ success: true }),
        };
      },
    } as unknown as D1Database,
    CICWTCH_ATTACHMENTS: {} as R2Bucket,
    API_BEARER_TOKEN: "test-secret-token",
  };
}

describe("route clients endpoint", () => {
  it("returns 401 when clients auth header is missing", async () => {
    const request = new Request("https://example.com/api/v1/clients");
    const response = await route(request, createEnv());

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: "unauthorized",
        message: "Missing or invalid bearer token",
      },
    });
  });

  it("returns JSON client list when auth header is valid", async () => {
    const request = new Request("https://example.com/api/v1/clients", {
      headers: {
        Authorization: "Bearer test-secret-token",
      },
    });

    const response = await route(request, createEnv());

    expect(response.status).toBe(200);

    const contentType = response.headers.get("Content-Type");
    expect(contentType).toBe("application/json");

    const body = await response.json();
    expect(Array.isArray(body)).toBe(true);
  });
});

describe("route behavior-snapshots endpoint", () => {
  it("returns 401 when auth header is missing", async () => {
    const request = new Request(
      "https://example.com/api/v1/dogs/dog-1/behavior-snapshots",
    );
    const response = await route(request, createEnv());

    expect(response.status).toBe(401);
  });

  it("returns JSON snapshot list when auth header is valid", async () => {
    const request = new Request(
      "https://example.com/api/v1/dogs/dog-1/behavior-snapshots",
      {
        headers: { Authorization: "Bearer test-secret-token" },
      },
    );

    const response = await route(request, createEnv());

    expect(response.status).toBe(200);
    const contentType = response.headers.get("Content-Type");
    expect(contentType).toBe("application/json");

    const body = await response.json();
    expect(Array.isArray(body)).toBe(true);
  });

  it("returns 405 for unsupported methods", async () => {
    const request = new Request(
      "https://example.com/api/v1/dogs/dog-1/behavior-snapshots",
      {
        method: "DELETE",
        headers: { Authorization: "Bearer test-secret-token" },
      },
    );

    const response = await route(request, createEnv());

    expect(response.status).toBe(405);
    expect(response.headers.get("Allow")).toBe("GET, POST");
  });
});

describe("route dashboard endpoint", () => {
  it("returns 401 when dashboard auth header is missing", async () => {
    const request = new Request("https://example.com/api/v1/dashboard");
    const response = await route(request, createEnv());

    expect(response.status).toBe(401);
    await expect(response.json()).resolves.toEqual({
      error: {
        code: "unauthorized",
        message: "Missing or invalid bearer token",
      },
    });
  });

  it("returns dashboard data when auth header is valid", async () => {
    const request = new Request("https://example.com/api/v1/dashboard", {
      headers: {
        Authorization: "Bearer test-secret-token",
      },
    });

    const response = await route(request, createEnv());

    expect(response.status).toBe(200);

    const contentType = response.headers.get("Content-Type");
    expect(contentType).toBe("application/json");

    await expect(response.json()).resolves.toEqual({
      clients: { total: 5 },
      dogs: { total: 12 },
      walks: { total: 40, today: 3, upcoming: 7 },
      walkers: { total: 4 },
      invoices: { total: 15, outstanding: 2 },
    });
  });

  it("returns 405 when dashboard is called with non-GET method", async () => {
    const request = new Request("https://example.com/api/v1/dashboard", {
      method: "POST",
      headers: {
        Authorization: "Bearer test-secret-token",
      },
    });

    const response = await route(request, createEnv());

    expect(response.status).toBe(405);
    expect(response.headers.get("Allow")).toBe("GET");
  });
});
