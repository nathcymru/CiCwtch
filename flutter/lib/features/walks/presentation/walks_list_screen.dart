import 'package:flutter/material.dart';

import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/empty_state_block.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/walk_status_badge.dart';

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _statusFilter;

  static const _statusOptions = [
    (value: 'planned', label: 'Planned'),
    (value: 'in_progress', label: 'In progress'),
    (value: 'completed', label: 'Completed'),
    (value: 'cancelled', label: 'Cancelled'),
  ];

  List<Walk> get _filteredWalks {
    final q = _searchQuery.toLowerCase().trim();
    return _walks.where((w) {
      final matchesSearch = q.isEmpty ||
          w.scheduledDate.toLowerCase().contains(q) ||
          w.status.toLowerCase().contains(q) ||
          w.serviceType.toLowerCase().contains(q) ||
          w.dogId.toLowerCase().contains(q) ||
          (w.walkerId?.toLowerCase().contains(q) ?? false);
      final matchesStatus =
          _statusFilter == null || w.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search walks...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _statusFilter == null,
                  onSelected: (_) => setState(() => _statusFilter = null),
                ),
                for (final option in _statusOptions)
                  FilterChip(
                    label: Text(option.label),
                    selected: _statusFilter == option.value,
                    onSelected: (_) => setState(() {
                      _statusFilter = _statusFilter == option.value
                          ? null
                          : option.value;
                    }),
                  ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ErrorStateBlock(message: _error!, onRetry: _load);
    }

    if (_walks.isEmpty) {
      return const EmptyStateBlock(
        icon: Icons.directions_walk_outlined,
        message: 'No walks found.',
      );
    }

    final filtered = _filteredWalks;

    if (filtered.isEmpty) {
      return const EmptyStateBlock(
        icon: Icons.search_off,
        message: 'No walks match the current search or filter.',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final walk = filtered[index];
          return ListTile(
            title: Text(walk.scheduledDate),
            subtitle: Row(
              children: [
                WalkStatusBadge(status: walk.status),
                const SizedBox(width: 8),
                Text(walk.serviceType,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
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
