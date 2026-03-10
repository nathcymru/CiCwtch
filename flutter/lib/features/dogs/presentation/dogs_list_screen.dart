import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/empty_state_block.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/summary_metric_card.dart';

import 'dog_avatar_widget.dart';
import 'dog_create_screen.dart';
import 'dog_detail_screen.dart';

class DogsListScreen extends StatefulWidget {
  const DogsListScreen({super.key});

  @override
  State<DogsListScreen> createState() => _DogsListScreenState();
}

class _DogsListScreenState extends State<DogsListScreen> {
  final _service = DogsService(
    DogsRepository(buildApiClient()),
  );

  List<Dog> _dogs = [];
  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Dog> get _filteredDogs {
    final q = _searchQuery.toLowerCase().trim();
    if (q.isEmpty) return _dogs;
    return _dogs.where((d) {
      return d.name.toLowerCase().contains(q) ||
          (d.breed?.toLowerCase().contains(q) ?? false) ||
          d.clientId.toLowerCase().contains(q);
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
      final dogs = await _service.listDogs();
      setState(() {
        _dogs = dogs;
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
      appBar: AppBar(title: const Text('Dogs')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const DogCreateScreen()),
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
                hintText: 'Search dogs...',
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
                    icon: Icons.pets,
                    label: 'Total dogs',
                    value: _dogs.length.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SummaryMetricCard(
                    icon: Icons.search,
                    label: 'Showing',
                    value: _filteredDogs.length.toString(),
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

    if (_dogs.isEmpty) {
      return const EmptyStateBlock(
        icon: Icons.pets_outlined,
        message: 'No dogs yet. Tap + to add one.',
      );
    }

    final filtered = _filteredDogs;

    if (filtered.isEmpty) {
      return EmptyStateBlock(
        icon: Icons.search_off,
        message: 'No dogs match "$_searchQuery".',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final dog = filtered[index];
          return ListTile(
            leading: DogAvatarWidget(dog: dog, radius: 20),
            title: Text(dog.name),
            subtitle: Text(dog.breedName ?? dog.breed ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => DogDetailScreen(dogId: dog.id),
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
