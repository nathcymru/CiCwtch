import 'package:flutter/material.dart';

import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walk_create_screen.dart';
import 'walk_detail_screen.dart';

class WalksListScreen extends StatefulWidget {
  const WalksListScreen({super.key});

  @override
  State<WalksListScreen> createState() => _WalksListScreenState();
}

class _WalksListScreenState extends State<WalksListScreen> {
  final _service = WalksService(
    WalksRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  List<Walk> _walks = [];
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
      final walks = await _service.listWalks();
      setState(() {
        _walks = walks;
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
      appBar: AppBar(title: const Text('Walks')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const WalkCreateScreen()),
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

    if (_walks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk_outlined, size: 64),
            SizedBox(height: 16),
            Text('No walks found.'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _walks.length,
        itemBuilder: (context, index) {
          final walk = _walks[index];
          return ListTile(
            title: Text(walk.scheduledDate),
            subtitle: Text('${walk.serviceType} — ${walk.status}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => WalkDetailScreen(walkId: walk.id),
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
