import { describe, it, expect } from "vitest";
import {
  calculatePawSafety,
  calculateBrachyFactor,
  calculateMudFactor,
  calculateItchFactor,
  calculateGearCheck,
  calculateDogFactors,
  buildDailyVerdict,
} from "./dogWeatherFactors";
import type { WeatherInput } from "./dogWeatherFactors";

// ─── Paw Safety ────────────────────────────────────────────────────────────

describe("calculatePawSafety", () => {
  it("returns Red when temp > 25 and condition is sunny", () => {
    const result = calculatePawSafety(26, 5, "Sunny");
    expect(result.status).toBe("Red");
    expect(result.actionableDetail).toBe("Toasty Toes Alert");
  });

  it("returns Yellow when temp is between 20 and 25", () => {
    const result = calculatePawSafety(22, 4, "Partly cloudy");
    expect(result.status).toBe("Yellow");
    expect(result.actionableDetail).toBe("Strictly Grass Only");
  });

  it("returns Yellow when uvIndex > 7", () => {
    const result = calculatePawSafety(15, 8, "Partly cloudy");
    expect(result.status).toBe("Yellow");
    expect(result.actionableDetail).toBe("Strictly Grass Only");
  });

  it("returns Green for mild safe conditions", () => {
    const result = calculatePawSafety(14, 2, "Cloudy");
    expect(result.status).toBe("Green");
    expect(result.actionableDetail).toBe("Pawsome Pavement");
  });

  it("returns Green when temp is > 25 but not sunny", () => {
    const result = calculatePawSafety(27, 5, "Overcast");
    expect(result.status).toBe("Green");
  });
});

// ─── Brachy Factor ─────────────────────────────────────────────────────────

describe("calculateBrachyFactor", () => {
  it("returns Red when temp > 28", () => {
    const result = calculateBrachyFactor(30, 50, 30);
    expect(result.status).toBe("Red");
    expect(result.actionableDetail).toBe("Pants Like Dragons");
  });

  it("returns Red when aqi > 100", () => {
    const result = calculateBrachyFactor(18, 50, 110);
    expect(result.status).toBe("Red");
  });

  it("returns Red when temp > 24 and humidity > 80", () => {
    const result = calculateBrachyFactor(25, 85, 30);
    expect(result.status).toBe("Red");
  });

  it("returns Yellow when temp is between 22 and 27", () => {
    const result = calculateBrachyFactor(24, 60, 30);
    expect(result.status).toBe("Yellow");
    expect(result.actionableDetail).toBe("Slow & Low");
  });

  it("returns Yellow when aqi is between 51 and 100", () => {
    const result = calculateBrachyFactor(15, 50, 75);
    expect(result.status).toBe("Yellow");
  });

  it("returns Green for comfortable conditions", () => {
    const result = calculateBrachyFactor(16, 55, 20);
    expect(result.status).toBe("Green");
    expect(result.actionableDetail).toBe("Easy Breezy Pups");
  });
});

// ─── Mud Factor ────────────────────────────────────────────────────────────

describe("calculateMudFactor", () => {
  it("returns Red when precip24h > 10", () => {
    const result = calculateMudFactor(15, false);
    expect(result.status).toBe("Red");
    expect(result.actionableDetail).toBe("Splish Splash Bath");
  });

  it("returns Red when it is currently raining", () => {
    const result = calculateMudFactor(0, true);
    expect(result.status).toBe("Red");
  });

  it("returns Yellow when precip24h is between 2 and 10", () => {
    const result = calculateMudFactor(5, false);
    expect(result.status).toBe("Yellow");
    expect(result.actionableDetail).toBe("Soggy Paw Patrol");
  });

  it("returns Green for dry conditions", () => {
    const result = calculateMudFactor(0, false);
    expect(result.status).toBe("Green");
    expect(result.actionableDetail).toBe("Dusty Doggy Day");
  });
});

// ─── Itch Factor ───────────────────────────────────────────────────────────

describe("calculateItchFactor", () => {
  it("returns Red for High pollen", () => {
    const result = calculateItchFactor("High");
    expect(result.status).toBe("Red");
    expect(result.actionableDetail).toBe("Scratchy Belly Vibes");
  });

  it("returns Red for Very High pollen", () => {
    const result = calculateItchFactor("Very High");
    expect(result.status).toBe("Red");
  });

  it("returns Yellow for Moderate pollen", () => {
    const result = calculateItchFactor("Moderate");
    expect(result.status).toBe("Yellow");
    expect(result.actionableDetail).toBe("Wipe Dat Underbelly");
  });

  it("returns Green for Low pollen", () => {
    const result = calculateItchFactor("Low");
    expect(result.status).toBe("Green");
    expect(result.actionableDetail).toBe("Zero Itch Energy");
  });
});

// ─── Gear Check ────────────────────────────────────────────────────────────

describe("calculateGearCheck", () => {
  it("returns Cool Mats Out when brachyStatus is Red", () => {
    const result = calculateGearCheck(25, "Sunny", "Red");
    expect(result.actionableDetail).toBe("Cool Mats Out");
  });

  it("returns Cool Mats Out when brachyStatus is Yellow", () => {
    const result = calculateGearCheck(24, "Sunny", "Yellow");
    expect(result.actionableDetail).toBe("Cool Mats Out");
  });

  it("returns Yellow Raincoat Time for rain condition", () => {
    const result = calculateGearCheck(12, "Light Rain", "Green");
    expect(result.actionableDetail).toBe("Yellow Raincoat Time");
  });

  it("returns Yellow Raincoat Time for drizzle condition", () => {
    const result = calculateGearCheck(10, "Drizzle", "Green");
    expect(result.actionableDetail).toBe("Yellow Raincoat Time");
  });

  it("returns Bundle Up Buttercup when feelsLike < 5", () => {
    const result = calculateGearCheck(2, "Clear", "Green");
    expect(result.actionableDetail).toBe("Bundle Up Buttercup");
  });

  it("returns Chilly Dog Sweater when feelsLike is between 5 and 12", () => {
    const result = calculateGearCheck(8, "Cloudy", "Green");
    expect(result.actionableDetail).toBe("Chilly Dog Sweater");
  });

  it("returns Rocking Birthday Suit for mild weather", () => {
    const result = calculateGearCheck(18, "Partly cloudy", "Green");
    expect(result.actionableDetail).toBe("Rocking Birthday Suit");
  });
});

// ─── calculateDogFactors integration ───────────────────────────────────────

describe("calculateDogFactors", () => {
  it("returns all Green for ideal UK spring day", () => {
    const input: WeatherInput = {
      airTemp: 14,
      feelsLike: 13,
      humidity: 55,
      uvIndex: 3,
      condition: "Partly cloudy",
      precip24h: 0,
      isRaining: false,
      pollenLevel: "Low",
      aqi: 20,
    };
    const factors = calculateDogFactors(input);
    expect(factors.pawSafety.status).toBe("Green");
    expect(factors.brachyFactor.status).toBe("Green");
    expect(factors.mudFactor.status).toBe("Green");
    expect(factors.itchFactor.status).toBe("Green");
  });

  it("returns Red brachy and Red paw safety for hot sunny day", () => {
    const input: WeatherInput = {
      airTemp: 30,
      feelsLike: 32,
      humidity: 40,
      uvIndex: 9,
      condition: "Sunny",
      precip24h: 0,
      isRaining: false,
      pollenLevel: "Low",
      aqi: 30,
    };
    const factors = calculateDogFactors(input);
    expect(factors.brachyFactor.status).toBe("Red");
    expect(factors.pawSafety.status).toBe("Red");
  });

  it("returns Red mud and Yellow itch for wet pollen day", () => {
    const input: WeatherInput = {
      airTemp: 16,
      feelsLike: 14,
      humidity: 70,
      uvIndex: 2,
      condition: "Overcast",
      precip24h: 15,
      isRaining: false,
      pollenLevel: "Moderate",
      aqi: 25,
    };
    const factors = calculateDogFactors(input);
    expect(factors.mudFactor.status).toBe("Red");
    expect(factors.itchFactor.status).toBe("Yellow");
  });
});

// ─── buildDailyVerdict ─────────────────────────────────────────────────────

describe("buildDailyVerdict", () => {
  const baseInput: WeatherInput = {
    airTemp: 14,
    feelsLike: 13,
    humidity: 55,
    uvIndex: 3,
    condition: "Partly cloudy",
    precip24h: 0,
    isRaining: false,
    pollenLevel: "Low",
    aqi: 20,
  };

  it("returns positive all-clear for all Green factors", () => {
    const factors = calculateDogFactors(baseInput);
    const verdict = buildDailyVerdict(factors, baseInput);
    expect(verdict).toMatch(/Perfect day:/i);
    expect(verdict).toContain("blue-ribbon");
  });

  it("prioritises brachy red first when temp is very high", () => {
    const input: WeatherInput = {
      ...baseInput,
      airTemp: 30,
      feelsLike: 32,
      humidity: 40,
      aqi: 30,
      condition: "Sunny",
    };
    const factors = calculateDogFactors(input);
    const verdict = buildDailyVerdict(factors, input);
    expect(verdict).toContain("Heads up:");
    expect(verdict).toContain("short-and-slow");
  });

  it("mentions mud advice for high precipitation", () => {
    const input: WeatherInput = {
      ...baseInput,
      precip24h: 15,
    };
    const factors = calculateDogFactors(input);
    const verdict = buildDailyVerdict(factors, input);
    expect(verdict).toContain("mucky");
  });

  it("mentions pollen advice for Red itch factor", () => {
    const input: WeatherInput = {
      ...baseInput,
      pollenLevel: "High",
    };
    const factors = calculateDogFactors(input);
    const verdict = buildDailyVerdict(factors, input);
    expect(verdict).toContain("Pollen");
  });

  it("mentions rain gear for rainy conditions with green brachy", () => {
    const input: WeatherInput = {
      ...baseInput,
      condition: "Light Rain",
    };
    const factors = calculateDogFactors(input);
    const verdict = buildDailyVerdict(factors, input);
    expect(verdict).toContain("Rain gear");
  });

  it("starts with Heads up when any factor is Red", () => {
    const input: WeatherInput = {
      ...baseInput,
      pollenLevel: "Very High",
    };
    const factors = calculateDogFactors(input);
    const verdict = buildDailyVerdict(factors, input);
    expect(verdict).toContain("Heads up:");
  });
});
