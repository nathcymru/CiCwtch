import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/features/dashboard/application/dashboard_service.dart';
import 'package:cicwtch/features/dashboard/application/weather_service.dart';
import 'package:cicwtch/features/dashboard/data/dashboard_repository.dart';
import 'package:cicwtch/features/dashboard/data/weather_repository.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';
import 'package:cicwtch/features/dashboard/domain/weather_data.dart';
import 'package:cicwtch/features/dashboard/presentation/dashboard_card.dart';
import 'package:cicwtch/features/dashboard/presentation/weather_card.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/section_heading.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardService _service;
  late final WeatherService _weatherService;

  DashboardData? _data;
  bool _loading = true;
  String? _error;

  WeatherData? _weatherData;
  bool _weatherLoading = true;

  @override
  void initState() {
    super.initState();
    final api = buildApiClient();
    _service = DashboardService(DashboardRepository(api));
    _weatherService = WeatherService(WeatherRepository(api));
    _load();
    _loadWeather();
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

  Future<void> _loadWeather() async {
    setState(() => _weatherLoading = true);
    try {
      final weather = await _weatherService.loadWeather();
      setState(() {
        _weatherData = weather;
        _weatherLoading = false;
      });
    } catch (_) {
      setState(() => _weatherLoading = false);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherSection(),
            const SizedBox(height: 24),
            const SectionHeading(title: 'Overview'),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                DashboardCard(icon: Icons.people, label: 'Total Clients', value: data.clientsTotal),
                DashboardCard(icon: Icons.pets, label: 'Total Dogs', value: data.dogsTotal),
                DashboardCard(icon: Icons.directions_walk, label: 'Total Walks', value: data.walksTotal),
                DashboardCard(icon: Icons.today, label: 'Walks Today', value: data.walksToday),
                DashboardCard(icon: Icons.upcoming, label: 'Upcoming Walks', value: data.walksUpcoming),
                DashboardCard(icon: Icons.badge, label: 'Total Walkers', value: data.walkersTotal),
                DashboardCard(icon: Icons.receipt_long, label: 'Total Invoices', value: data.invoicesTotal),
                DashboardCard(icon: Icons.warning_amber, label: 'Outstanding Invoices', value: data.invoicesOutstanding),
              ],
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

  Widget _buildWeatherSection() {
    if (_weatherLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text("Loading today's weather…"),
            ],
          ),
        ),
      );
    }
    if (_weatherData == null) {
      return const SizedBox.shrink();
    }
    return WeatherCard(weatherData: _weatherData!);
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
