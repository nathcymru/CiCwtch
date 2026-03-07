import 'package:flutter/material.dart';

import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walker_detail_screen.dart';
import 'walker_create_screen.dart';

class WalkersListScreen extends StatefulWidget {
  const WalkersListScreen({super.key});

  @override
  State<WalkersListScreen> createState() => _WalkersListScreenState();
}

class _WalkersListScreenState extends State<WalkersListScreen> {
  final _service = WalkersService(
    WalkersRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  List<Walker> _walkers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final walkers = await _service.listWalkers();
      setState(() {
        _walkers = walkers;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Walkers')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const WalkerCreateScreen()),
          );
          if (created == true) _load();
        },
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
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

    if (_walkers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk_outlined, size: 64),
            SizedBox(height: 16),
            Text('No walkers yet. Tap + to add one.'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _walkers.length,
        itemBuilder: (context, index) {
          final walker = _walkers[index];
          return ListTile(
            title: Text(walker.fullName),
            subtitle: Text(walker.phone ?? walker.email ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => WalkerDetailScreen(walkerId: walker.id),
                ),
              );
              if (changed == true) _load();
            },
          );
        },
      ),
    );
  }
}
