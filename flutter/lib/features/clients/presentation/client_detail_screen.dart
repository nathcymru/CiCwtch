import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/detail_row.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/form_date_helper.dart';

import 'client_edit_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({super.key, required this.clientId});

  final String clientId;

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final _service = ClientsService(
    ClientsRepository(buildApiClient()),
  );

  Client? _client;
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
      final client = await _service.getClient(widget.clientId);
      setState(() {
        _client = client;
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
        title: const Text('Archive client?'),
        content: const Text('This will archive the client.'),
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
      await _service.deleteClient(widget.clientId);
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
    final title = _client?.fullName ?? 'Client';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _client == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientEditScreen(client: _client!),
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
      return ErrorStateBlock(message: _error!, onRetry: _load);
    }

    if (_client == null) return const SizedBox.shrink();

    final client = _client!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DetailRow(label: 'Full name', value: client.fullName),
        if (client.preferredName != null)
          DetailRow(label: 'Preferred name', value: client.preferredName!),
        if (client.phone != null)
          DetailRow(label: 'Phone', value: client.phone!),
        if (client.email != null)
          DetailRow(label: 'Email', value: client.email!),
        if (client.emergencyContactName != null)
          DetailRow(
              label: 'Emergency contact', value: client.emergencyContactName!),
        if (client.emergencyContactPhone != null)
          DetailRow(
              label: 'Emergency phone', value: client.emergencyContactPhone!),
        if (client.notes != null)
          DetailRow(label: 'Notes', value: client.notes!),
        const Divider(height: 32),
        DetailRow(label: 'Created', value: formatDetailDate(client.createdAt)),
        DetailRow(label: 'Updated', value: formatDetailDate(client.updatedAt)),
      ],
    );
  }
}
