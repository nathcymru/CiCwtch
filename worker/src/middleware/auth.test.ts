import { describe, it, expect } from "vitest";
import { requireBearerToken } from "./auth";

const EXPECTED_TOKEN = "test-secret-token";
const API_URL = "https://cicwtch-api.nathcymru.workers.dev/api/v1/clients";

/* ------------------------------------------------------------------ */
/*  Missing token                                                      */
/* ------------------------------------------------------------------ */

describe("requireBearerToken — missing token", () => {
  it("returns 401 when no Authorization header is present", () => {
    const req = new Request(API_URL);
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });

  it("returns a JSON error body when no Authorization header is present", async () => {
    const req = new Request(API_URL);
    const result = requireBearerToken(req, EXPECTED_TOKEN);
    const body = await result!.json() as { error: { message: string; code: string } };

    expect(body.error.code).toBe("unauthorized");
    expect(body.error.message).toBe("Missing or invalid bearer token");
  });
});

/* ------------------------------------------------------------------ */
/*  Invalid token                                                      */
/* ------------------------------------------------------------------ */

describe("requireBearerToken — invalid token", () => {
  it("returns 401 when Authorization header has wrong format", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Basic abc123" },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });

  it("returns a JSON error body for wrong format", async () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Basic abc123" },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);
    const body = await result!.json() as { error: { message: string; code: string } };

    expect(body.error.code).toBe("unauthorized");
    expect(body.error.message).toBe("Missing or invalid bearer token");
  });

  it("returns 401 when bearer token does not match", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Bearer wrong-token" },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });

  it("returns a JSON error body for mismatched token", async () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Bearer wrong-token" },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);
    const body = await result!.json() as { error: { message: string; code: string } };

    expect(body.error.code).toBe("unauthorized");
    expect(body.error.message).toBe("Missing or invalid bearer token");
  });

  it("returns 401 when Bearer prefix is missing the space", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: `Bearer${EXPECTED_TOKEN}` },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });

  it("returns 401 for an empty token after Bearer prefix", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Bearer " },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });
});

/* ------------------------------------------------------------------ */
/*  Valid token                                                        */
/* ------------------------------------------------------------------ */

describe("requireBearerToken — valid token", () => {
  it("returns null when the bearer token matches", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: `Bearer ${EXPECTED_TOKEN}` },
    });
    const result = requireBearerToken(req, EXPECTED_TOKEN);

    expect(result).toBeNull();
  });
});

/* ------------------------------------------------------------------ */
/*  Token not configured                                               */
/* ------------------------------------------------------------------ */

describe("requireBearerToken — token not configured", () => {
  it("returns 401 when expectedToken is undefined", () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Bearer some-token" },
    });
    const result = requireBearerToken(req, undefined);

    expect(result).not.toBeNull();
    expect(result!.status).toBe(401);
  });

  it("returns unauthorized error code when token is undefined", async () => {
    const req = new Request(API_URL, {
      headers: { Authorization: "Bearer some-token" },
    });
    const result = requireBearerToken(req, undefined);
    const body = await result!.json() as { error: { message: string; code: string } };

    expect(body.error.code).toBe("unauthorized");
    expect(body.error.message).toBe("Missing or invalid bearer token");
  });
});
