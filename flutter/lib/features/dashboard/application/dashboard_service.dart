import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class DashboardService {
  DashboardService({
    required this.clientsService,
    required this.dogsService,
    required this.walksService,
    required this.walkersService,
    required this.invoicesService,
  });

  final ClientsService clientsService;
  final DogsService dogsService;
  final WalksService walksService;
  final WalkersService walkersService;
  final InvoicesService invoicesService;

  Future<DashboardData> load() async {
    final results = await Future.wait([
      clientsService.listClients(),
      dogsService.listDogs(),
      walksService.listWalks(),
      walkersService.listWalkers(),
      invoicesService.listInvoices(),
    ]);

    final clients = results[0] as List<Client>;
    final dogs = results[1] as List<Dog>;
    final walks = results[2] as List<Walk>;
    final walkers = results[3] as List<Walker>;
    final invoices = results[4] as List<InvoiceHeader>;

    final activeClients = clients.where((c) => c.archivedAt == null).length;
    final activeDogs = dogs.where((d) => d.archivedAt == null).length;
    final activeWalks = walks.where((w) => w.archivedAt == null).length;
    final activeWalkers = walkers.where((w) => w.archivedAt == null && w.active).length;
    final activeInvoices = invoices.where((i) => i.archivedAt == null).length;

    final recentWalks = walks.where((w) => w.archivedAt == null).toList()
      ..sort((a, b) {
        final dateCompare = a.scheduledDate.compareTo(b.scheduledDate);
        if (dateCompare != 0) return dateCompare;
        return (a.scheduledStartTime ?? '').compareTo(b.scheduledStartTime ?? '');
      });

    return DashboardData(
      activeClients: activeClients,
      activeDogs: activeDogs,
      activeWalks: activeWalks,
      activeWalkers: activeWalkers,
      activeInvoices: activeInvoices,
      recentWalks: recentWalks.take(5).toList(),
    );
  }
}
