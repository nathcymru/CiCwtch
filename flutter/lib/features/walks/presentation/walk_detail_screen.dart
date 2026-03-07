import 'package:flutter/material.dart';

import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walk_edit_screen.dart';

class WalkDetailScreen extends StatefulWidget {
  const WalkDetailScreen({super.key, required this.walkId});

  final String walkId;

  @override
  State<WalkDetailScreen> createState() => _WalkDetailScreenState();
}

class _WalkDetailScreenState extends State<WalkDetailScreen> {
  final _service = WalksService(
    WalksRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  Walk? _walk;
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
      final walk = await _service.getWalk(widget.walkId);
      setState(() {
        _walk = walk;
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
        title: const Text('Archive walk?'),
        content: const Text('This will archive the walk.'),
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
      await _service.deleteWalk(widget.walkId);
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
    final title = _walk?.scheduledDate ?? 'Walk';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _walk == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WalkEditScreen(walk: _walk!),
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

    if (_walk == null) return const SizedBox.shrink();

    final walk = _walk!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailRow(label: 'Scheduled date', value: walk.scheduledDate),
        _DetailRow(label: 'Status', value: walk.status),
        _DetailRow(label: 'Service type', value: walk.serviceType),
        _DetailRow(label: 'Client ID', value: walk.clientId),
        _DetailRow(label: 'Dog ID', value: walk.dogId),
        if (walk.walkerId != null)
          _DetailRow(label: 'Walker ID', value: walk.walkerId!),
        if (walk.scheduledStartTime != null)
          _DetailRow(
              label: 'Scheduled start', value: walk.scheduledStartTime!),
        if (walk.scheduledEndTime != null)
          _DetailRow(label: 'Scheduled end', value: walk.scheduledEndTime!),
        if (walk.actualStartTime != null)
          _DetailRow(label: 'Actual start', value: walk.actualStartTime!),
        if (walk.actualEndTime != null)
          _DetailRow(label: 'Actual end', value: walk.actualEndTime!),
        if (walk.pickupAddressId != null)
          _DetailRow(
              label: 'Pickup address ID', value: walk.pickupAddressId!),
        if (walk.notes != null)
          _DetailRow(label: 'Notes', value: walk.notes!),
        const Divider(height: 32),
        _DetailRow(label: 'Created', value: _formatDate(walk.createdAt)),
        _DetailRow(label: 'Updated', value: _formatDate(walk.updatedAt)),
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
