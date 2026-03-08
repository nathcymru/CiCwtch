import 'package:flutter/material.dart';

import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/form_error_banner.dart';
import 'package:cicwtch/shared/presentation/invoice_status_badge.dart';
import 'package:cicwtch/shared/presentation/section_heading.dart';

const _statusOptions = ['draft', 'issued', 'paid', 'cancelled'];

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({
    super.key,
    this.invoice,
    required this.onSubmit,
  });

  final InvoiceHeader? invoice;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _clientId;
  late final TextEditingController _invoiceNumber;
  late String _status;
  late final TextEditingController _issueDate;
  late final TextEditingController _dueDate;
  late final TextEditingController _currencyCode;
  late final TextEditingController _notes;

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final inv = widget.invoice;
    _clientId = TextEditingController(text: inv?.clientId ?? '');
    _invoiceNumber = TextEditingController(text: inv?.invoiceNumber ?? '');
    _status = inv?.status ?? 'draft';
    _issueDate = TextEditingController(text: inv?.issueDate ?? '');
    _dueDate = TextEditingController(text: inv?.dueDate ?? '');
    _currencyCode =
        TextEditingController(text: inv?.currencyCode ?? 'GBP');
    _notes = TextEditingController(text: inv?.notes ?? '');
  }

  @override
  void dispose() {
    _clientId.dispose();
    _invoiceNumber.dispose();
    _issueDate.dispose();
    _dueDate.dispose();
    _currencyCode.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final issueDateVal = _issueDate.text.trim();
    final dueDateVal = _dueDate.text.trim();
    final notesVal = _notes.text.trim();

    final payload = <String, dynamic>{
      'client_id': _clientId.text.trim(),
      'invoice_number': _invoiceNumber.text.trim(),
      'status': _status,
      'currency_code': _currencyCode.text.trim(),
      if (issueDateVal.isNotEmpty) 'issue_date': issueDateVal,
      if (dueDateVal.isNotEmpty) 'due_date': dueDateVal,
      if (notesVal.isNotEmpty) 'notes': notesVal,
    };

    try {
      await widget.onSubmit(payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _submitting = false;
        _submitError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.invoice != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Invoice' : 'New Invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_submitError != null)
                FormErrorBanner(message: _submitError!),
              const SectionHeading(title: 'Invoice details'),
              TextFormField(
                controller: _clientId,
                decoration: const InputDecoration(
                  labelText: 'Client ID *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _invoiceNumber,
                decoration: const InputDecoration(
                  labelText: 'Invoice number *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: InvoiceStatusBadge(status: s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _status = v);
                },
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currencyCode,
                decoration: const InputDecoration(
                  labelText: 'Currency code *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              const SectionHeading(title: 'Optional details'),
              TextFormField(
                controller: _issueDate,
                decoration: const InputDecoration(
                  labelText: 'Issue date',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDate,
                decoration: const InputDecoration(
                  labelText: 'Due date',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              const SectionHeading(title: 'Payment tracking'),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? 'Save changes' : 'Create invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
