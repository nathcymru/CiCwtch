import 'package:cicwtch/shared/domain/models/models.dart';

class DashboardData {
  const DashboardData({
    required this.activeClients,
    required this.activeDogs,
    required this.activeWalks,
    required this.activeWalkers,
    required this.recentWalks,
  });

  final int activeClients;
  final int activeDogs;
  final int activeWalks;
  final int activeWalkers;
  final List<Walk> recentWalks;
}
