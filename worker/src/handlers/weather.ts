import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import {
  calculateDogFactors,
  buildDailyVerdict,
} from "../services/dogWeatherFactors";
import type { WeatherInput } from "../services/dogWeatherFactors";

const GOOGLE_WEATHER_BASE = "https://weather.googleapis.com/v1";

// Default to central London when no location is supplied.
const DEFAULT_LAT = 51.5074;
const DEFAULT_LNG = -0.1278;

interface GoogleCurrentConditions {
  temperature?: { degrees?: number };
  feelsLikeTemperature?: { degrees?: number };
  humidity?: number;
  uvIndex?: number;
  precipitation?: {
    qpf?: { quantity?: number };
    probability?: { percent?: number; type?: string };
  };
  weatherCondition?: {
    iconBaseUri?: string;
    description?: { text?: string };
    type?: string;
  };
  airQuality?: { index?: number };
}

interface GoogleCurrentResponse {
  currentConditions?: GoogleCurrentConditions;
}

interface GoogleDayForecast {
  daytimeForecast?: {
    precipitation?: {
      qpf?: { quantity?: number };
    };
    weatherCondition?: {
      description?: { text?: string };
      iconBaseUri?: string;
    };
    temperature?: {
      high?: { degrees?: number };
      low?: { degrees?: number };
    };
  };
  weatherConditions?: Array<{
    alerts?: Array<{
      severity?: string;
    }>;
  }>;
}

interface GoogleForecastResponse {
  forecastDays?: GoogleDayForecast[];
}

function parsePollen(
  uvIndex: number,
): "Low" | "Moderate" | "High" | "Very High" {
  // Google Weather API does not currently expose a pollen field in its
  // standard currentConditions response.  We derive a proxy value from
  // UV index as a reasonable same-day heuristic.
  if (uvIndex >= 8) return "Very High";
  if (uvIndex >= 6) return "High";
  if (uvIndex >= 3) return "Moderate";
  return "Low";
}

function parseWarning(
  forecastDays: GoogleDayForecast[] | undefined,
): { level: "Red" | "Amber" | "Yellow" } | null {
  if (!forecastDays || forecastDays.length === 0) return null;
  const day = forecastDays[0];
  const alerts = day.weatherConditions?.flatMap((wc) => wc.alerts ?? []) ?? [];
  if (alerts.length === 0) return null;

  const severities = alerts.map((a) => (a.severity ?? "").toLowerCase());
  if (severities.includes("red") || severities.includes("extreme")) {
    return { level: "Red" };
  }
  if (severities.includes("amber") || severities.includes("severe")) {
    return { level: "Amber" };
  }
  return { level: "Yellow" };
}

export async function getWeatherToday(
  request: Request,
  env: Env,
): Promise<Response> {
  const apiKey = env.CICWTCH_GOOGLE_WEATHER_API;
  if (!apiKey) {
    return jsonError(
      "Weather API key is not configured",
      "configuration_error",
      503,
    );
  }

  const url = new URL(request.url);
  const lat = parseFloat(url.searchParams.get("lat") ?? String(DEFAULT_LAT));
  const lng = parseFloat(url.searchParams.get("lng") ?? String(DEFAULT_LNG));

  if (isNaN(lat) || isNaN(lng)) {
    return jsonError("Invalid lat/lng parameters", "validation_error", 400);
  }

  const currentUrl = `${GOOGLE_WEATHER_BASE}/currentConditions:lookup?key=${apiKey}&location.latitude=${lat}&location.longitude=${lng}&unitsSystem=METRIC`;
  const forecastUrl = `${GOOGLE_WEATHER_BASE}/forecast/days:lookup?key=${apiKey}&location.latitude=${lat}&location.longitude=${lng}&days=1&unitsSystem=METRIC`;

  let currentData: GoogleCurrentResponse;
  let forecastData: GoogleForecastResponse;

  try {
    const [currentRes, forecastRes] = await Promise.all([
      fetch(currentUrl),
      fetch(forecastUrl),
    ]);

    if (!currentRes.ok) {
      const text = await currentRes.text();
      console.error("Google Weather current conditions error:", text);
      return jsonError(
        "Failed to fetch current weather conditions",
        "upstream_error",
        502,
      );
    }
    if (!forecastRes.ok) {
      const text = await forecastRes.text();
      console.error("Google Weather forecast error:", text);
      return jsonError("Failed to fetch weather forecast", "upstream_error", 502);
    }

    currentData = (await currentRes.json()) as GoogleCurrentResponse;
    forecastData = (await forecastRes.json()) as GoogleForecastResponse;
  } catch (err) {
    console.error("Weather fetch error:", err);
    return jsonError("Unable to reach weather service", "upstream_error", 502);
  }

  const cc = currentData.currentConditions ?? {};
  const forecastDay = forecastData.forecastDays?.[0];
  const daytime = forecastDay?.daytimeForecast;

  const airTemp = cc.temperature?.degrees ?? 15;
  const feelsLike = cc.feelsLikeTemperature?.degrees ?? airTemp;
  const humidity = cc.humidity ?? 60;
  const uvIndex = cc.uvIndex ?? 0;
  const condition =
    cc.weatherCondition?.description?.text ??
    daytime?.weatherCondition?.description?.text ??
    "Partly cloudy";
  const iconBaseUri =
    cc.weatherCondition?.iconBaseUri ??
    daytime?.weatherCondition?.iconBaseUri ??
    null;
  const aqi = cc.airQuality?.index ?? 0;
  const precipCurrent = cc.precipitation?.qpf?.quantity ?? 0;
  const precipForecast = daytime?.precipitation?.qpf?.quantity ?? 0;
  const precip24h = precipCurrent + precipForecast;
  const isRaining =
    (cc.precipitation?.probability?.type ?? "").toLowerCase() === "rain" &&
    (cc.precipitation?.probability?.percent ?? 0) > 50;

  const pollenLevel = parsePollen(uvIndex);

  const weatherInput: WeatherInput = {
    airTemp,
    feelsLike,
    humidity,
    uvIndex,
    condition,
    precip24h,
    isRaining,
    pollenLevel,
    aqi,
  };

  const factors = calculateDogFactors(weatherInput);
  const verdict = buildDailyVerdict(factors, weatherInput);
  const warning = parseWarning(forecastData.forecastDays);

  return jsonOk({
    location: { lat, lng },
    current: {
      airTemp,
      feelsLike,
      humidity,
      uvIndex,
      condition,
      iconBaseUri,
      aqi,
      precip24h,
      isRaining,
      pollenLevel,
    },
    warning,
    factors,
    verdict,
  });
}
