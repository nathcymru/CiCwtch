import { describe, it, expect } from "vitest";
import { getAllowedOrigin, handlePreflight, withCorsHeaders } from "./cors";

/* ------------------------------------------------------------------ */
/*  getAllowedOrigin                                                    */
/* ------------------------------------------------------------------ */

describe("getAllowedOrigin", () => {
  it("returns the origin for the production app domain", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://cicwtch.app" },
    });
    expect(getAllowedOrigin(req)).toBe("https://cicwtch.app");
  });

  it("returns the origin for the Pages production domain", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://cicwtch.pages.dev" },
    });
    expect(getAllowedOrigin(req)).toBe("https://cicwtch.pages.dev");
  });

  it("returns the origin for a Pages preview deployment", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://abc123.cicwtch.pages.dev" },
    });
    expect(getAllowedOrigin(req)).toBe("https://abc123.cicwtch.pages.dev");
  });

  it("returns the origin for a Pages preview deployment with dashes", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://abc-123-def.cicwtch.pages.dev" },
    });
    expect(getAllowedOrigin(req)).toBe("https://abc-123-def.cicwtch.pages.dev");
  });

  it("returns the origin for localhost", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "http://localhost:8080" },
    });
    expect(getAllowedOrigin(req)).toBe("http://localhost:8080");
  });

  it("returns the origin for localhost without port", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "http://localhost" },
    });
    expect(getAllowedOrigin(req)).toBe("http://localhost");
  });

  it("returns null when no Origin header is present", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients");
    expect(getAllowedOrigin(req)).toBeNull();
  });

  it("returns null for an empty Origin header", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "" },
    });
    expect(getAllowedOrigin(req)).toBeNull();
  });

  it("returns null for an unrecognised origin", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://evil.example.com" },
    });
    expect(getAllowedOrigin(req)).toBeNull();
  });

  it("rejects http scheme for the production domain", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "http://cicwtch.app" },
    });
    expect(getAllowedOrigin(req)).toBeNull();
  });
});

/* ------------------------------------------------------------------ */
/*  handlePreflight                                                    */
/* ------------------------------------------------------------------ */

describe("handlePreflight", () => {
  it("returns 204 with CORS headers for a valid origin", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      method: "OPTIONS",
      headers: {
        Origin: "https://cicwtch.app",
        "Access-Control-Request-Method": "GET",
        "Access-Control-Request-Headers": "content-type",
      },
    });

    const res = handlePreflight(req);

    expect(res.status).toBe(204);
    expect(res.headers.get("Access-Control-Allow-Origin")).toBe("https://cicwtch.app");
    expect(res.headers.get("Access-Control-Allow-Methods")).toContain("GET");
    expect(res.headers.get("Access-Control-Allow-Methods")).toContain("POST");
    expect(res.headers.get("Access-Control-Allow-Methods")).toContain("PUT");
    expect(res.headers.get("Access-Control-Allow-Methods")).toContain("DELETE");
    expect(res.headers.get("Access-Control-Allow-Methods")).toContain("OPTIONS");
    expect(res.headers.get("Access-Control-Allow-Headers")).toContain("Content-Type");
    expect(res.headers.get("Access-Control-Allow-Headers")).toContain("Authorization");
    expect(res.headers.get("Access-Control-Max-Age")).toBe("86400");
  });

  it("returns 204 without CORS headers for an unrecognised origin", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      method: "OPTIONS",
      headers: {
        Origin: "https://evil.example.com",
        "Access-Control-Request-Method": "GET",
      },
    });

    const res = handlePreflight(req);

    expect(res.status).toBe(204);
    expect(res.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });

  it("returns 204 without CORS headers when no Origin header is present", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      method: "OPTIONS",
    });

    const res = handlePreflight(req);

    expect(res.status).toBe(204);
    expect(res.headers.get("Access-Control-Allow-Origin")).toBeNull();
  });
});

/* ------------------------------------------------------------------ */
/*  withCorsHeaders                                                    */
/* ------------------------------------------------------------------ */

describe("withCorsHeaders", () => {
  it("adds CORS headers to a response for a valid origin", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://cicwtch.app" },
    });
    const original = new Response(JSON.stringify({ data: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

    const res = withCorsHeaders(original, req);

    expect(res.status).toBe(200);
    expect(res.headers.get("Access-Control-Allow-Origin")).toBe("https://cicwtch.app");
    expect(res.headers.get("Vary")).toBe("Origin");
    expect(res.headers.get("Content-Type")).toBe("application/json");
  });

  it("does not add CORS headers for an unrecognised origin", () => {
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://evil.example.com" },
    });
    const original = new Response(JSON.stringify({ data: [] }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

    const res = withCorsHeaders(original, req);

    expect(res.headers.get("Access-Control-Allow-Origin")).toBeNull();
    expect(res.headers.get("Vary")).toBeNull();
  });

  it("preserves the original response body", async () => {
    const body = JSON.stringify({ data: [{ id: "abc" }] });
    const req = new Request("https://cicwtch-api.nathcymru.workers.dev/api/v1/clients", {
      headers: { Origin: "https://cicwtch.app" },
    });
    const original = new Response(body, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

    const res = withCorsHeaders(original, req);
    const text = await res.text();

    expect(text).toBe(body);
  });
});
