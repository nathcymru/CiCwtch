import 'package:cicwtch/features/dashboard/data/weather_repository.dart';
import 'package:cicwtch/features/dashboard/domain/weather_data.dart';

class WeatherService {
  WeatherService(this._repository);

  final WeatherRepository _repository;

  Future<WeatherData> loadWeather({double? lat, double? lng}) =>
      _repository.getWeatherToday(lat: lat, lng: lng);
}
