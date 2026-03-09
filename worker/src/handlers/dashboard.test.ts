import { describe, it, expect, vi } from "vitest";
import { getDashboard } from "./dashboard";
import type { Env } from "../index";

function mockEnv(counts: Record<string, number>): Env {
  const queries: string[] = [];

  return {
    DB: {
      prepare(sql: string) {
        queries.push(sql);
        return {
          first: () => Promise.resolve({ count: counts[sql] ?? 0 }),
        };
      },
    },
    CICWTCH_ATTACHMENTS: {},
  } as unknown as Env;
}

describe("getDashboard", () => {
  it("returns aggregate counts in the expected shape", async () => {
    const env = mockEnv({
      "SELECT COUNT(*) AS count FROM clients WHERE archived_at IS NULL": 5,
      "SELECT COUNT(*) AS count FROM dogs WHERE archived_at IS NULL": 12,
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL": 40,
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date = date('now')": 3,
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date > date('now')": 7,
      "SELECT COUNT(*) AS count FROM walkers WHERE archived_at IS NULL": 4,
      "SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL": 15,
      "SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL AND status = 'issued'": 2,
    });

    const request = new Request("https://example.com/api/v1/dashboard");
    const response = await getDashboard(request, env);

    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body).toEqual({
      clients: { total: 5 },
      dogs: { total: 12 },
      walks: { total: 40, today: 3, upcoming: 7 },
      walkers: { total: 4 },
      invoices: { total: 15, outstanding: 2 },
    });
  });

  it("defaults to zero when queries return null", async () => {
    const env = {
      DB: {
        prepare() {
          return {
            first: () => Promise.resolve(null),
          };
        },
      },
      CICWTCH_ATTACHMENTS: {},
    } as unknown as Env;

    const request = new Request("https://example.com/api/v1/dashboard");
    const response = await getDashboard(request, env);

    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body).toEqual({
      clients: { total: 0 },
      dogs: { total: 0 },
      walks: { total: 0, today: 0, upcoming: 0 },
      walkers: { total: 0 },
      invoices: { total: 0, outstanding: 0 },
    });
  });
});
