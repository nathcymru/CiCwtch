import 'package:cicwtch/features/dashboard/domain/weather_data.dart';
import 'package:cicwtch/shared/data/api_client.dart';

class WeatherRepository {
  WeatherRepository(this._api);

  final ApiClient _api;

  Future<WeatherData> getWeatherToday({double? lat, double? lng}) async {
    final query = StringBuffer('/api/v1/weather/today');
    if (lat != null && lng != null) {
      query.write('?lat=$lat&lng=$lng');
    }
    final json = await _api.get(query.toString()) as Map<String, dynamic>;
    return WeatherData.fromJson(json);
  }
}
