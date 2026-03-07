import 'package:flutter/material.dart';

import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walker_edit_screen.dart';

class WalkerDetailScreen extends StatefulWidget {
  const WalkerDetailScreen({super.key, required this.walkerId});

  final String walkerId;

  @override
  State<WalkerDetailScreen> createState() => _WalkerDetailScreenState();
}

class _WalkerDetailScreenState extends State<WalkerDetailScreen> {
  final _service = WalkersService(
    WalkersRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  Walker? _walker;
  bool _loading = true;
  String? _error;
  bool _deleting = false;

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
      final walker = await _service.getWalker(widget.walkerId);
      setState(() {
        _walker = walker;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archive walker?'),
        content: const Text('This will archive the walker.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    try {
      await _service.deleteWalker(widget.walkerId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _deleting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _walker?.fullName ?? 'Walker';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _walker == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WalkerEditScreen(walker: _walker!),
                      ),
                    );
                    if (updated == true) _load();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: _deleting ? null : _confirmDelete,
                ),
              ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading || _deleting) {
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

    if (_walker == null) return const SizedBox.shrink();

    final walker = _walker!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailRow(label: 'Full name', value: walker.fullName),
        if (walker.phone != null)
          _DetailRow(label: 'Phone', value: walker.phone!),
        if (walker.email != null)
          _DetailRow(label: 'Email', value: walker.email!),
        if (walker.roleTitle != null)
          _DetailRow(label: 'Role', value: walker.roleTitle!),
        if (walker.startDate != null)
          _DetailRow(label: 'Start date', value: walker.startDate!),
        _DetailRow(label: 'Active', value: walker.active ? 'Yes' : 'No'),
        if (walker.notes != null)
          _DetailRow(label: 'Notes', value: walker.notes!),
        const Divider(height: 32),
        _DetailRow(label: 'Created', value: _formatDate(walker.createdAt)),
        _DetailRow(label: 'Updated', value: _formatDate(walker.updatedAt)),
      ],
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
