import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/shared/data/api_client.dart';

class DashboardRepository {
  DashboardRepository(this._api);

  final ApiClient _api;

  Future<DashboardData> getDashboard() async {
    final json =
        await _api.get('/api/v1/dashboard') as Map<String, dynamic>;
    return DashboardData.fromJson(json);
  }
}
