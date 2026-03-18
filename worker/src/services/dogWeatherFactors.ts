export type FactorStatus = "Green" | "Yellow" | "Red";

export interface DogFactor {
  status: FactorStatus;
  actionableDetail: string;
}

export interface GearCheck {
  actionableDetail: string;
}

export interface DogFactors {
  pawSafety: DogFactor;
  brachyFactor: DogFactor;
  mudFactor: DogFactor;
  itchFactor: DogFactor;
  gearCheck: GearCheck;
}

export interface WeatherInput {
  airTemp: number;
  feelsLike: number;
  humidity: number;
  uvIndex: number;
  condition: string;
  precip24h: number;
  isRaining: boolean;
  pollenLevel: "Low" | "Moderate" | "High" | "Very High";
  aqi: number;
}

export function calculatePawSafety(
  airTemp: number,
  uvIndex: number,
  condition: string,
): DogFactor {
  const isSunny =
    condition.toLowerCase().includes("sun") ||
    condition.toLowerCase().includes("clear");

  if (airTemp > 25 && isSunny) {
    return { status: "Red", actionableDetail: "Toasty Toes Alert" };
  }
  if ((airTemp >= 20 && airTemp <= 25) || uvIndex > 7) {
    return { status: "Yellow", actionableDetail: "Strictly Grass Only" };
  }
  return { status: "Green", actionableDetail: "Pawsome Pavement" };
}

export function calculateBrachyFactor(
  airTemp: number,
  humidity: number,
  aqi: number,
): DogFactor {
  if (airTemp > 28 || aqi > 100 || (airTemp > 24 && humidity > 80)) {
    return { status: "Red", actionableDetail: "Pants Like Dragons" };
  }
  if ((airTemp >= 22 && airTemp <= 27) || (aqi >= 51 && aqi <= 100)) {
    return { status: "Yellow", actionableDetail: "Slow & Low" };
  }
  return { status: "Green", actionableDetail: "Easy Breezy Pups" };
}

export function calculateMudFactor(
  precip24h: number,
  isRaining: boolean,
): DogFactor {
  if (precip24h > 10 || isRaining) {
    return { status: "Red", actionableDetail: "Splish Splash Bath" };
  }
  if (precip24h >= 2 && precip24h <= 10) {
    return { status: "Yellow", actionableDetail: "Soggy Paw Patrol" };
  }
  return { status: "Green", actionableDetail: "Dusty Doggy Day" };
}

export function calculateItchFactor(
  pollenLevel: "Low" | "Moderate" | "High" | "Very High",
): DogFactor {
  if (pollenLevel === "High" || pollenLevel === "Very High") {
    return { status: "Red", actionableDetail: "Scratchy Belly Vibes" };
  }
  if (pollenLevel === "Moderate") {
    return { status: "Yellow", actionableDetail: "Wipe Dat Underbelly" };
  }
  return { status: "Green", actionableDetail: "Zero Itch Energy" };
}

export function calculateGearCheck(
  feelsLike: number,
  condition: string,
  brachyStatus: FactorStatus,
): GearCheck {
  if (brachyStatus === "Red" || brachyStatus === "Yellow") {
    return { actionableDetail: "Cool Mats Out" };
  }
  const conditionLower = condition.toLowerCase();
  if (conditionLower.includes("rain") || conditionLower.includes("drizzle")) {
    return { actionableDetail: "Yellow Raincoat Time" };
  }
  if (feelsLike < 5) {
    return { actionableDetail: "Bundle Up Buttercup" };
  }
  if (feelsLike >= 5 && feelsLike <= 12) {
    return { actionableDetail: "Chilly Dog Sweater" };
  }
  return { actionableDetail: "Rocking Birthday Suit" };
}

export function calculateDogFactors(weatherInput: WeatherInput): DogFactors {
  const pawSafety = calculatePawSafety(
    weatherInput.airTemp,
    weatherInput.uvIndex,
    weatherInput.condition,
  );
  const brachyFactor = calculateBrachyFactor(
    weatherInput.airTemp,
    weatherInput.humidity,
    weatherInput.aqi,
  );
  const mudFactor = calculateMudFactor(
    weatherInput.precip24h,
    weatherInput.isRaining,
  );
  const itchFactor = calculateItchFactor(weatherInput.pollenLevel);
  const gearCheck = calculateGearCheck(
    weatherInput.feelsLike,
    weatherInput.condition,
    brachyFactor.status,
  );

  return { pawSafety, brachyFactor, mudFactor, itchFactor, gearCheck };
}

export function buildDailyVerdict(
  factors: DogFactors,
  weatherInput: WeatherInput,
): string {
  const verdictParts: string[] = [];
  const hasAnyRed =
    factors.brachyFactor.status === "Red" ||
    factors.pawSafety.status === "Red" ||
    factors.mudFactor.status === "Red" ||
    factors.itchFactor.status === "Red";

  const allSafetyGreen =
    factors.brachyFactor.status === "Green" &&
    factors.pawSafety.status === "Green" &&
    factors.mudFactor.status === "Green" &&
    factors.itchFactor.status === "Green";

  const intro = hasAnyRed ? "Heads up:" : "";

  // Priority 1 — Brachy / heat / breathing
  if (factors.brachyFactor.status === "Red") {
    verdictParts.push(
      "Safety first: it's a short-and-slow day. High heat or humidity means shade and fresh water are non-negotiable.",
    );
  } else if (factors.brachyFactor.status === "Yellow") {
    verdictParts.push(
      "Keep it cool today—pace yourselves and take breaks in the shade.",
    );
  }

  // Priority 2 — Paw safety
  if (
    factors.pawSafety.status === "Red" ||
    factors.pawSafety.status === "Yellow"
  ) {
    verdictParts.push(
      "Watch those paws. Hard surfaces are heating up, so stick to grass, shaded paths, or cooler trails.",
    );
  }

  // Priority 3 — Mud / rain
  if (factors.mudFactor.status === "Red") {
    verdictParts.push(
      "Expect a mucky one. The ground is a sponge, so budget for a serious towel-down afterwards.",
    );
  }

  // Priority 4 — Itch / pollen
  if (factors.itchFactor.status === "Red") {
    verdictParts.push(
      "Pollen is peaking, so keep sensitive dogs out of long grass where possible.",
    );
  } else if (factors.itchFactor.status === "Yellow") {
    verdictParts.push(
      "Moderate pollen today—give bellies a quick wipe-down after the walk.",
    );
  }

  // Rain gear tip — add when brachy is not flagged but condition indicates rain
  const conditionLower = weatherInput.condition.toLowerCase();
  const isRainyCondition =
    conditionLower.includes("rain") || conditionLower.includes("drizzle");
  if (factors.brachyFactor.status === "Green" && isRainyCondition) {
    verdictParts.push("Rain gear at the ready—showers are on the cards.");
  }

  if (verdictParts.length === 0) {
    if (allSafetyGreen) {
      return "Perfect day: it's a blue-ribbon day—excellent conditions for a longer romp.";
    }
    return "Perfect walking conditions! Enjoy the trails.";
  }

  if (allSafetyGreen && isRainyCondition) {
    return `Perfect day (bar the showers): ${verdictParts.join(" ")}`;
  }

  const body = verdictParts.join(" ");
  return intro ? `${intro} ${body}` : body;
}
