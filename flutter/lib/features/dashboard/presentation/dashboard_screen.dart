import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/features/dashboard/application/dashboard_service.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/section_heading.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardService _service;

  DashboardData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final api = ApiClient(baseUrl: ApiConfig.baseUrl);
    _service = DashboardService(
      clientsService: ClientsService(ClientsRepository(api)),
      dogsService: DogsService(DogsRepository(api)),
      walksService: WalksService(WalksRepository(api)),
      walkersService: WalkersService(WalkersRepository(api)),
      invoicesService: InvoicesService(InvoicesRepository(api)),
    );
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.load();
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: ErrorStateBlock(message: _error!, onRetry: _load),
      );
    }

    final data = _data!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'Overview'),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _MetricCard(icon: Icons.people, label: 'Active Clients', value: data.activeClients, colorScheme: colorScheme, textTheme: textTheme),
                _MetricCard(icon: Icons.pets, label: 'Active Dogs', value: data.activeDogs, colorScheme: colorScheme, textTheme: textTheme),
                _MetricCard(icon: Icons.directions_walk, label: 'Active Walks', value: data.activeWalks, colorScheme: colorScheme, textTheme: textTheme),
                _MetricCard(icon: Icons.badge, label: 'Active Walkers', value: data.activeWalkers, colorScheme: colorScheme, textTheme: textTheme),
                _MetricCard(icon: Icons.receipt_long, label: 'Active Invoices', value: data.activeInvoices, colorScheme: colorScheme, textTheme: textTheme),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeading(title: 'Upcoming walks'),
            if (data.recentWalks.isEmpty)
              Text('No walks found.', style: textTheme.bodyMedium)
            else
              Column(
                children: data.recentWalks.map((walk) => Card(
                  child: ListTile(
                    title: Text(walk.scheduledDate),
                    subtitle: Text('${walk.serviceType} — ${walk.status}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.walkDetail, arguments: walk.id),
                  ),
                )).toList(),
              ),
            const SizedBox(height: 24),
            const SectionHeading(title: 'Go to'),
            Column(
              children: const [
                _NavTile(icon: Icons.people, title: 'Clients', routeName: AppRoutes.clientsList),
                _NavTile(icon: Icons.pets, title: 'Dogs', routeName: AppRoutes.dogsList),
                _NavTile(icon: Icons.directions_walk, title: 'Walks', routeName: AppRoutes.walksList),
                _NavTile(icon: Icons.badge, title: 'Walkers', routeName: AppRoutes.walkersList),
                _NavTile(icon: Icons.receipt_long, title: 'Invoices', routeName: AppRoutes.invoicesList),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final int value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value.toString(), style: textTheme.titleLarge),
                  Text(label, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.title, required this.routeName});

  final IconData icon;
  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, routeName),
    );
  }
}
