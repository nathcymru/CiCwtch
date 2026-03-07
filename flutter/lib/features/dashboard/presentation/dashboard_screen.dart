import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/features/dashboard/application/dashboard_service.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';

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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
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
            // Section 1 – Overview
            Text('Overview', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _MetricCard(
                  icon: Icons.people,
                  label: 'Active Clients',
                  value: data.activeClients,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _MetricCard(
                  icon: Icons.pets,
                  label: 'Active Dogs',
                  value: data.activeDogs,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _MetricCard(
                  icon: Icons.directions_walk,
                  label: 'Active Walks',
                  value: data.activeWalks,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _MetricCard(
                  icon: Icons.badge,
                  label: 'Active Walkers',
                  value: data.activeWalkers,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),

            // Section 2 – Upcoming Walks
            const SizedBox(height: 24),
            Text('Upcoming Walks', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            if (data.recentWalks.isEmpty)
              Text('No walks found.', style: textTheme.bodyMedium)
            else
              Column(
                children: data.recentWalks
                    .map(
                      (walk) => Card(
                        child: ListTile(
                          title: Text(walk.scheduledDate),
                          subtitle:
                              Text('${walk.serviceType} — ${walk.status}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.walkDetail,
                            arguments: walk.id,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

            // Section 3 – Quick Navigation
            const SizedBox(height: 24),
            Text('Go to', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Clients'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.clientsList),
                ),
                ListTile(
                  leading: const Icon(Icons.pets),
                  title: const Text('Dogs'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.dogsList),
                ),
                ListTile(
                  leading: const Icon(Icons.directions_walk),
                  title: const Text('Walks'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.walksList),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Walkers'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.walkersList),
                ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value.toString(), style: textTheme.titleLarge),
                Text(label, style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
