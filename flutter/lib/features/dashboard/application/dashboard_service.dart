import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class DashboardService {
  DashboardService({
    required this.clientsService,
    required this.dogsService,
    required this.walksService,
    required this.walkersService,
  });

  final ClientsService clientsService;
  final DogsService dogsService;
  final WalksService walksService;
  final WalkersService walkersService;

  Future<DashboardData> load() async {
    final results = await Future.wait([
      clientsService.listClients(),
      dogsService.listDogs(),
      walksService.listWalks(),
      walkersService.listWalkers(),
    ]);

    final clients = results[0] as List<Client>;
    final dogs = results[1] as List<Dog>;
    final walks = results[2] as List<Walk>;
    final walkers = results[3] as List<Walker>;

    final activeClients = clients.where((c) => c.archivedAt == null).length;
    final activeDogs = dogs.where((d) => d.archivedAt == null).length;
    final activeWalks = walks.where((w) => w.archivedAt == null).length;
    final activeWalkers =
        walkers.where((w) => w.archivedAt == null && w.active).length;

    final recentWalks = walks
        .where((w) => w.archivedAt == null)
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    final top5 = recentWalks.take(5).toList();

    return DashboardData(
      activeClients: activeClients,
      activeDogs: activeDogs,
      activeWalks: activeWalks,
      activeWalkers: activeWalkers,
      recentWalks: top5,
    );
  }
}
