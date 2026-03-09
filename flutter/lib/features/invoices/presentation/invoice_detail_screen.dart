import 'package:flutter/material.dart';

import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/detail_row.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/form_date_helper.dart';
import 'package:cicwtch/shared/presentation/invoice_status_badge.dart';

import 'invoice_edit_screen.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final _service = InvoicesService(
    InvoicesRepository(buildApiClient()),
  );

  InvoiceHeader? _invoice;
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
      final invoice = await _service.getInvoice(widget.invoiceId);
      setState(() {
        _invoice = invoice;
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
        title: const Text('Archive Invoice?'),
        content: const Text(
            'This invoice will be archived and removed from the active list.'),
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
      await _service.deleteInvoice(widget.invoiceId);
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
    final title = _invoice?.invoiceNumber ?? 'Invoice';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _invoice == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InvoiceEditScreen(invoice: _invoice!),
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

    if (_invoice == null) return const SizedBox.shrink();

    final invoice = _invoice!;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                child: Text('Status', style: theme.textTheme.labelLarge),
              ),
              InvoiceStatusBadge(status: invoice.status),
            ],
          ),
        ),
        DetailRow(label: 'Invoice number', value: invoice.invoiceNumber),
        DetailRow(label: 'Client ID', value: invoice.clientId),
        DetailRow(label: 'Currency', value: invoice.currencyCode),
        if (invoice.issueDate != null)
          DetailRow(label: 'Issue date', value: invoice.issueDate!),
        if (invoice.dueDate != null)
          DetailRow(label: 'Due date', value: invoice.dueDate!),
        if (invoice.notes != null)
          DetailRow(label: 'Notes', value: invoice.notes!),
        const Divider(height: 32),
        DetailRow(
            label: 'Created', value: formatDetailDate(invoice.createdAt)),
        DetailRow(
            label: 'Updated', value: formatDetailDate(invoice.updatedAt)),
      ],
    );
  }
}
