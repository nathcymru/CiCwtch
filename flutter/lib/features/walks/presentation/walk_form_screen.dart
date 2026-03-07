import 'package:flutter/material.dart';

import 'package:cicwtch/shared/domain/models/models.dart';

class WalkFormScreen extends StatefulWidget {
  const WalkFormScreen({
    super.key,
    this.walk,
    required this.onSubmit,
  });

  final Walk? walk;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<WalkFormScreen> createState() => _WalkFormScreenState();
}

class _WalkFormScreenState extends State<WalkFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _clientId;
  late final TextEditingController _dogId;
  late final TextEditingController _walkerId;
  late final TextEditingController _scheduledDate;
  late final TextEditingController _scheduledStartTime;
  late final TextEditingController _scheduledEndTime;
  late final TextEditingController _notes;

  String _status = 'scheduled';
  String _serviceType = 'solo_walk';

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final w = widget.walk;
    _clientId = TextEditingController(text: w?.clientId ?? '');
    _dogId = TextEditingController(text: w?.dogId ?? '');
    _walkerId = TextEditingController(text: w?.walkerId ?? '');
    _scheduledDate = TextEditingController(text: w?.scheduledDate ?? '');
    _scheduledStartTime =
        TextEditingController(text: w?.scheduledStartTime ?? '');
    _scheduledEndTime =
        TextEditingController(text: w?.scheduledEndTime ?? '');
    _notes = TextEditingController(text: w?.notes ?? '');
    _status = w?.status ?? 'scheduled';
    _serviceType = w?.serviceType ?? 'solo_walk';
  }

  @override
  void dispose() {
    _clientId.dispose();
    _dogId.dispose();
    _walkerId.dispose();
    _scheduledDate.dispose();
    _scheduledStartTime.dispose();
    _scheduledEndTime.dispose();
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
      'client_id': _clientId.text.trim(),
      'dog_id': _dogId.text.trim(),
      'scheduled_date': _scheduledDate.text.trim(),
      'status': _status,
      'service_type': _serviceType,
      if (_walkerId.text.trim().isNotEmpty)
        'walker_id': _walkerId.text.trim(),
      if (_scheduledStartTime.text.trim().isNotEmpty)
        'scheduled_start_time': _scheduledStartTime.text.trim(),
      if (_scheduledEndTime.text.trim().isNotEmpty)
        'scheduled_end_time': _scheduledEndTime.text.trim(),
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
    final isEdit = widget.walk != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Walk' : 'New Walk'),
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
                controller: _dogId,
                decoration: const InputDecoration(
                  labelText: 'Dog ID *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduledDate,
                decoration: const InputDecoration(
                  labelText: 'Scheduled date (YYYY-MM-DD) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'scheduled', child: Text('Scheduled')),
                  DropdownMenuItem(
                      value: 'in_progress', child: Text('In progress')),
                  DropdownMenuItem(
                      value: 'completed', child: Text('Completed')),
                  DropdownMenuItem(
                      value: 'cancelled', child: Text('Cancelled')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'scheduled'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _serviceType,
                decoration: const InputDecoration(
                  labelText: 'Service type *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'group_walk', child: Text('Group walk')),
                  DropdownMenuItem(
                      value: 'solo_walk', child: Text('Solo walk')),
                  DropdownMenuItem(
                      value: 'home_visit', child: Text('Home visit')),
                  DropdownMenuItem(
                      value: 'drop_in', child: Text('Drop in')),
                ],
                onChanged: (v) =>
                    setState(() => _serviceType = v ?? 'solo_walk'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _walkerId,
                decoration: const InputDecoration(
                  labelText: 'Walker ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduledStartTime,
                decoration: const InputDecoration(
                  labelText: 'Scheduled start time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduledEndTime,
                decoration: const InputDecoration(
                  labelText: 'Scheduled end time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                    : Text(isEdit ? 'Save changes' : 'Create walk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
