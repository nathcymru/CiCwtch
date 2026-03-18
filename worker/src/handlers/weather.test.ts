import { describe, it, expect, vi, afterEach } from "vitest";
import { getWeatherToday } from "./weather";
import type { Env } from "../index";

const API_URL = "https://cicwtch-api.nathcymru.workers.dev/api/v1/weather/today";

function makeEnv(apiKey?: string): Env {
  return {
    DB: {} as D1Database,
    CICWTCH_ATTACHMENTS: {} as R2Bucket,
    CICWTCH_GOOGLE_WEATHER_API: apiKey,
    CICWTCH_GOOGLE_WEATHER_SECRET: undefined,
  } as unknown as Env;
}

const VALID_CURRENT = {
  temperature: { degrees: 14 },
  feelsLikeTemperature: { degrees: 12 },
  relativeHumidity: 70,
  uvIndex: 2,
  precipitation: {
    qpf: { quantity: 0.5 },
    probability: { percent: 20, type: "RAIN" },
  },
  weatherCondition: {
    iconBaseUri: "https://example.com/icon.png",
    description: { text: "Cloudy" },
    type: "CLOUDY",
  },
  airQuality: { index: 30 },
};

const VALID_FORECAST = {
  forecastDays: [
    {
      daytimeForecast: {
        precipitation: {
          qpf: { quantity: 1.0 },
          probability: { percent: 30, type: "RAIN" },
        },
        weatherCondition: {
          description: { text: "Partly cloudy" },
          iconBaseUri: "https://example.com/icon2.png",
        },
        relativeHumidity: 65,
        uvIndex: 3,
      },
    },
  ],
};

afterEach(() => {
  vi.restoreAllMocks();
});

// ─── Missing API key ──────────────────────────────────────────────────────────

describe("getWeatherToday — missing API key", () => {
  it("returns 503 when CICWTCH_GOOGLE_WEATHER_API is not configured", async () => {
    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv(undefined));

    expect(response.status).toBe(503);
    const body = await response.json() as { error: { code: string; message: string } };
    expect(body.error.code).toBe("configuration_error");
  });
});

// ─── Invalid parameters ───────────────────────────────────────────────────────

describe("getWeatherToday — invalid parameters", () => {
  it("returns 400 for non-numeric lat", async () => {
    const request = new Request(`${API_URL}?lat=abc&lng=0`);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(400);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("validation_error");
  });

  it("returns 400 for non-numeric lng", async () => {
    const request = new Request(`${API_URL}?lat=51.5&lng=xyz`);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(400);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("validation_error");
  });
});

// ─── Upstream API failure ────────────────────────────────────────────────────

describe("getWeatherToday — upstream API failure", () => {
  it("returns 502 when the current conditions endpoint returns a non-OK status", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response("Unauthorized", { status: 401 }),
        )
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_FORECAST), { status: 200 }),
        ),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("bad-key"));

    expect(response.status).toBe(502);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("upstream_error");
  });

  it("returns 502 when the forecast endpoint returns a non-OK status", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_CURRENT), { status: 200 }),
        )
        .mockResolvedValueOnce(
          new Response("Internal Server Error", { status: 500 }),
        ),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(502);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("upstream_error");
  });

  it("returns 502 when the network call throws", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockRejectedValue(new Error("Network failure")),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(502);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("upstream_error");
  });
});

// ─── Invalid upstream response body ─────────────────────────────────────────

describe("getWeatherToday — invalid upstream response body", () => {
  it("returns 502 when the upstream response is not valid JSON", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response("not-json", { status: 200 }),
        )
        .mockResolvedValueOnce(
          new Response("also-not-json", { status: 200 }),
        ),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(502);
    const body = await response.json() as { error: { code: string } };
    expect(body.error.code).toBe("upstream_error");
  });
});

// ─── Successful response ─────────────────────────────────────────────────────

describe("getWeatherToday — successful response", () => {
  it("returns 200 with the expected JSON shape", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_CURRENT), { status: 200 }),
        )
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_FORECAST), { status: 200 }),
        ),
    );

    const request = new Request(`${API_URL}?lat=51.5&lng=-0.1`);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(200);
    const body = await response.json() as {
      location: { lat: number; lng: number };
      current: {
        airTemp: number;
        feelsLike: number;
        humidity: number;
        uvIndex: number;
        condition: string;
        aqi: number;
        precip24h: number;
        isRaining: boolean;
        pollenLevel: string;
        iconBaseUri: string | null;
      };
      factors: {
        pawSafety: { status: string; actionableDetail: string };
        brachyFactor: { status: string; actionableDetail: string };
        mudFactor: { status: string; actionableDetail: string };
        itchFactor: { status: string; actionableDetail: string };
        gearCheck: { actionableDetail: string };
      };
      verdict: string;
      warning: null | { level: string };
    };

    expect(body.location).toEqual({ lat: 51.5, lng: -0.1 });
    expect(body.current.airTemp).toBe(14);
    expect(body.current.feelsLike).toBe(12);
    expect(body.current.humidity).toBe(70);
    expect(body.current.uvIndex).toBe(2);
    expect(body.current.condition).toBe("Cloudy");
    expect(body.current.aqi).toBe(30);
    expect(typeof body.current.precip24h).toBe("number");
    expect(typeof body.current.isRaining).toBe("boolean");
    expect(typeof body.current.pollenLevel).toBe("string");

    expect(body.factors).toBeDefined();
    expect(body.factors.pawSafety).toBeDefined();
    expect(body.factors.brachyFactor).toBeDefined();
    expect(body.factors.mudFactor).toBeDefined();
    expect(body.factors.itchFactor).toBeDefined();
    expect(body.factors.gearCheck).toBeDefined();

    expect(typeof body.verdict).toBe("string");
    expect(body.verdict.length).toBeGreaterThan(0);
  });

  it("uses default lat/lng when query params are absent", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_CURRENT), { status: 200 }),
        )
        .mockResolvedValueOnce(
          new Response(JSON.stringify(VALID_FORECAST), { status: 200 }),
        ),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(200);
    const body = await response.json() as { location: { lat: number; lng: number } };
    // Default location is central London
    expect(body.location.lat).toBe(51.5074);
    expect(body.location.lng).toBe(-0.1278);
  });

  it("handles sparse upstream responses gracefully using fallback values", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn()
        .mockResolvedValueOnce(
          new Response(JSON.stringify({}), { status: 200 }),
        )
        .mockResolvedValueOnce(
          new Response(JSON.stringify({}), { status: 200 }),
        ),
    );

    const request = new Request(API_URL);
    const response = await getWeatherToday(request, makeEnv("test-key"));

    expect(response.status).toBe(200);
    const body = await response.json() as {
      current: { airTemp: number; condition: string; pollenLevel: string };
    };
    // Fallback values should kick in
    expect(body.current.airTemp).toBe(15);
    expect(body.current.condition).toBe("Partly cloudy");
    expect(body.current.pollenLevel).toBe("Low");
  });
});
