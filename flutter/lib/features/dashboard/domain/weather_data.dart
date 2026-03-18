class WeatherWarning {
  const WeatherWarning({required this.level});

  final String level; // 'Red' | 'Amber' | 'Yellow'

  factory WeatherWarning.fromJson(Map<String, dynamic> json) {
    return WeatherWarning(level: json['level'] as String);
  }
}

class DogFactor {
  const DogFactor({required this.status, required this.actionableDetail});

  final String status; // 'Green' | 'Yellow' | 'Red'
  final String actionableDetail;

  factory DogFactor.fromJson(Map<String, dynamic> json) {
    return DogFactor(
      status: json['status'] as String,
      actionableDetail: json['actionableDetail'] as String,
    );
  }
}

class GearCheck {
  const GearCheck({required this.actionableDetail});

  final String actionableDetail;

  factory GearCheck.fromJson(Map<String, dynamic> json) {
    return GearCheck(actionableDetail: json['actionableDetail'] as String);
  }
}

class DogFactors {
  const DogFactors({
    required this.pawSafety,
    required this.brachyFactor,
    required this.mudFactor,
    required this.itchFactor,
    required this.gearCheck,
  });

  final DogFactor pawSafety;
  final DogFactor brachyFactor;
  final DogFactor mudFactor;
  final DogFactor itchFactor;
  final GearCheck gearCheck;

  factory DogFactors.fromJson(Map<String, dynamic> json) {
    return DogFactors(
      pawSafety: DogFactor.fromJson(json['pawSafety'] as Map<String, dynamic>),
      brachyFactor: DogFactor.fromJson(json['brachyFactor'] as Map<String, dynamic>),
      mudFactor: DogFactor.fromJson(json['mudFactor'] as Map<String, dynamic>),
      itchFactor: DogFactor.fromJson(json['itchFactor'] as Map<String, dynamic>),
      gearCheck: GearCheck.fromJson(json['gearCheck'] as Map<String, dynamic>),
    );
  }
}

class WeatherCurrent {
  const WeatherCurrent({
    required this.airTemp,
    required this.feelsLike,
    required this.humidity,
    required this.uvIndex,
    required this.condition,
    required this.aqi,
    required this.precip24h,
    required this.isRaining,
    required this.pollenLevel,
    this.iconBaseUri,
  });

  final double airTemp;
  final double feelsLike;
  final int humidity;
  final int uvIndex;
  final String condition;
  final int aqi;
  final double precip24h;
  final bool isRaining;
  final String pollenLevel;
  final String? iconBaseUri;

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) {
    return WeatherCurrent(
      airTemp: (json['airTemp'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      uvIndex: (json['uvIndex'] as num).toInt(),
      condition: json['condition'] as String,
      aqi: (json['aqi'] as num).toInt(),
      precip24h: (json['precip24h'] as num).toDouble(),
      isRaining: json['isRaining'] as bool,
      pollenLevel: json['pollenLevel'] as String,
      iconBaseUri: json['iconBaseUri'] as String?,
    );
  }
}

class WeatherData {
  const WeatherData({
    required this.current,
    required this.factors,
    required this.verdict,
    this.warning,
  });

  final WeatherCurrent current;
  final DogFactors factors;
  final String verdict;
  final WeatherWarning? warning;

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final warningJson = json['warning'];
    return WeatherData(
      current: WeatherCurrent.fromJson(json['current'] as Map<String, dynamic>),
      factors: DogFactors.fromJson(json['factors'] as Map<String, dynamic>),
      verdict: json['verdict'] as String,
      warning: warningJson != null
          ? WeatherWarning.fromJson(warningJson as Map<String, dynamic>)
          : null,
    );
  }
}
