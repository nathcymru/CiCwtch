import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/empty_state_block.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/summary_metric_card.dart';

import 'client_detail_screen.dart';
import 'client_create_screen.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final _service = ClientsService(
    ClientsRepository(buildApiClient()),
  );

  List<Client> _clients = [];
  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Client> get _filteredClients {
    final q = _searchQuery.toLowerCase().trim();
    if (q.isEmpty) return _clients;
    return _clients.where((c) {
      return c.fullName.toLowerCase().contains(q) ||
          (c.preferredName?.toLowerCase().contains(q) ?? false) ||
          (c.phone?.toLowerCase().contains(q) ?? false) ||
          (c.email?.toLowerCase().contains(q) ?? false);
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
      final clients = await _service.listClients();
      setState(() {
        _clients = clients;
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
      appBar: AppBar(title: const Text('Clients')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const ClientCreateScreen()),
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
                hintText: 'Search clients...',
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
            child: Row(
              children: [
                Expanded(
                  child: SummaryMetricCard(
                    icon: Icons.people,
                    label: 'Total clients',
                    value: _clients.length.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SummaryMetricCard(
                    icon: Icons.search,
                    label: 'Showing',
                    value: _filteredClients.length.toString(),
                  ),
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

    if (_clients.isEmpty) {
      return const EmptyStateBlock(
        icon: Icons.people_outline,
        message: 'No clients yet. Tap + to add one.',
      );
    }

    final filtered = _filteredClients;

    if (filtered.isEmpty) {
      return EmptyStateBlock(
        icon: Icons.search_off,
        message: 'No clients match "$_searchQuery".',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final client = filtered[index];
          return ListTile(
            title: Text(client.fullName),
            subtitle: Text(client.phone ?? client.email ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientDetailScreen(clientId: client.id),
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
