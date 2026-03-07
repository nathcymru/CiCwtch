import 'package:flutter/material.dart';

import 'package:cicwtch/shared/domain/models/models.dart';

class WalkerFormScreen extends StatefulWidget {
  const WalkerFormScreen({
    super.key,
    this.walker,
    required this.onSubmit,
  });

  final Walker? walker;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<WalkerFormScreen> createState() => _WalkerFormScreenState();
}

final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class _WalkerFormScreenState extends State<WalkerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _roleTitle;
  late final TextEditingController _startDate;
  late final TextEditingController _notes;
  late bool _active;

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final w = widget.walker;
    _fullName = TextEditingController(text: w?.fullName ?? '');
    _phone = TextEditingController(text: w?.phone ?? '');
    _email = TextEditingController(text: w?.email ?? '');
    _roleTitle = TextEditingController(text: w?.roleTitle ?? '');
    _startDate = TextEditingController(text: w?.startDate ?? '');
    _notes = TextEditingController(text: w?.notes ?? '');
    _active = w?.active ?? true;
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _roleTitle.dispose();
    _startDate.dispose();
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
      'active': _active ? 1 : 0,
      if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
      if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
      if (_roleTitle.text.trim().isNotEmpty)
        'role_title': _roleTitle.text.trim(),
      if (_startDate.text.trim().isNotEmpty)
        'start_date': _startDate.text.trim(),
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
    final isEdit = widget.walker != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Walker' : 'New Walker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_submitError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _submitError!,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
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
                controller: _roleTitle,
                decoration: const InputDecoration(
                  labelText: 'Role title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDate,
                decoration: const InputDecoration(
                  labelText: 'Start date',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Active'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
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
                    : Text(isEdit ? 'Save changes' : 'Create walker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
