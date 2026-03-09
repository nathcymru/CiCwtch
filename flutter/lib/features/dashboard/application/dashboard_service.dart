import 'package:cicwtch/features/dashboard/data/dashboard_repository.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';

class DashboardService {
  DashboardService(this._repository);

  final DashboardRepository _repository;

  Future<DashboardData> load() => _repository.getDashboard();
}
