import 'package:flutter/material.dart';

import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/empty_state_block.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';

import 'package:cicwtch/shared/presentation/invoice_status_badge.dart';

import 'invoice_create_screen.dart';
import 'invoice_detail_screen.dart';

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  final _service = InvoicesService(
    InvoicesRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  List<InvoiceHeader> _invoices = [];
  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<InvoiceHeader> get _filteredInvoices {
    final q = _searchQuery.toLowerCase().trim();
    if (q.isEmpty) return _invoices;
    return _invoices.where((inv) {
      return inv.invoiceNumber.toLowerCase().contains(q) ||
          inv.clientId.toLowerCase().contains(q) ||
          inv.status.toLowerCase().contains(q) ||
          inv.currencyCode.toLowerCase().contains(q);
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
      final invoices = await _service.listInvoices();
      setState(() {
        _invoices = invoices;
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
      appBar: AppBar(title: const Text('Invoices')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const InvoiceCreateScreen()),
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
                hintText: 'Search invoices...',
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

    if (_invoices.isEmpty) {
      return const EmptyStateBlock(
        icon: Icons.receipt_long_outlined,
        message: 'No invoices yet. Tap + to add one.',
      );
    }

    final filtered = _filteredInvoices;

    if (filtered.isEmpty) {
      return EmptyStateBlock(
        icon: Icons.search_off,
        message: 'No invoices match "$_searchQuery".',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final invoice = filtered[index];
          return ListTile(
            title: Text(invoice.invoiceNumber),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice.clientId),
                const SizedBox(height: 4),
                Row(
                  children: [
                    InvoiceStatusBadge(status: invoice.status),
                    if (invoice.dueDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Due: ${invoice.dueDate}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      InvoiceDetailScreen(invoiceId: invoice.id),
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
