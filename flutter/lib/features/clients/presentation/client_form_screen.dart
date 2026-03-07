import 'package:flutter/material.dart';

import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/form_error_banner.dart';

class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({
    super.key,
    this.client,
    required this.onSubmit,
  });

  final Client? client;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullName;
  late final TextEditingController _preferredName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _emergencyContactName;
  late final TextEditingController _emergencyContactPhone;
  late final TextEditingController _notes;

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _fullName = TextEditingController(text: c?.fullName ?? '');
    _preferredName = TextEditingController(text: c?.preferredName ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _emergencyContactName =
        TextEditingController(text: c?.emergencyContactName ?? '');
    _emergencyContactPhone =
        TextEditingController(text: c?.emergencyContactPhone ?? '');
    _notes = TextEditingController(text: c?.notes ?? '');
  }

  @override
  void dispose() {
    _fullName.dispose();
    _preferredName.dispose();
    _phone.dispose();
    _email.dispose();
    _emergencyContactName.dispose();
    _emergencyContactPhone.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final payload = <String, dynamic>{
      'full_name': _fullName.text.trim(),
      if (_preferredName.text.trim().isNotEmpty)
        'preferred_name': _preferredName.text.trim(),
      if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
      if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
      if (_emergencyContactName.text.trim().isNotEmpty)
        'emergency_contact_name': _emergencyContactName.text.trim(),
      if (_emergencyContactPhone.text.trim().isNotEmpty)
        'emergency_contact_phone': _emergencyContactPhone.text.trim(),
      if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
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
    final isEdit = widget.client != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Client' : 'New Client'),
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
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: 'Full name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preferredName,
                decoration: const InputDecoration(
                  labelText: 'Preferred name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (!_emailRegex.hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyContactName,
                decoration: const InputDecoration(
                  labelText: 'Emergency contact name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyContactPhone,
                decoration: const InputDecoration(
                  labelText: 'Emergency contact phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
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
                    : Text(isEdit ? 'Save changes' : 'Create client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
