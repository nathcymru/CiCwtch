import 'package:flutter/material.dart';

import 'package:cicwtch/shared/domain/models/models.dart';

class DogFormScreen extends StatefulWidget {
  const DogFormScreen({
    super.key,
    this.dog,
    required this.onSubmit,
  });

  final Dog? dog;
  final Future<void> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<DogFormScreen> createState() => _DogFormScreenState();
}

class _DogFormScreenState extends State<DogFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _clientId;
  late final TextEditingController _breed;
  late final TextEditingController _dateOfBirth;
  late final TextEditingController _colour;
  late final TextEditingController _microchipNumber;
  late final TextEditingController _veterinaryPractice;
  late final TextEditingController _medicalNotes;
  late final TextEditingController _behaviouralNotes;
  late final TextEditingController _feedingNotes;

  String _sex = '';
  bool _neutered = false;

  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    final d = widget.dog;
    _name = TextEditingController(text: d?.name ?? '');
    _clientId = TextEditingController(text: d?.clientId ?? '');
    _breed = TextEditingController(text: d?.breed ?? '');
    _dateOfBirth = TextEditingController(text: d?.dateOfBirth ?? '');
    _colour = TextEditingController(text: d?.colour ?? '');
    _microchipNumber = TextEditingController(text: d?.microchipNumber ?? '');
    _veterinaryPractice =
        TextEditingController(text: d?.veterinaryPractice ?? '');
    _medicalNotes = TextEditingController(text: d?.medicalNotes ?? '');
    _behaviouralNotes =
        TextEditingController(text: d?.behaviouralNotes ?? '');
    _feedingNotes = TextEditingController(text: d?.feedingNotes ?? '');
    _sex = d?.sex ?? '';
    _neutered = d?.neutered ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _clientId.dispose();
    _breed.dispose();
    _dateOfBirth.dispose();
    _colour.dispose();
    _microchipNumber.dispose();
    _veterinaryPractice.dispose();
    _medicalNotes.dispose();
    _behaviouralNotes.dispose();
    _feedingNotes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      'client_id': _clientId.text.trim(),
      'neutered': _neutered ? 1 : 0,
      if (_breed.text.trim().isNotEmpty) 'breed': _breed.text.trim(),
      if (_sex.isNotEmpty) 'sex': _sex,
      if (_dateOfBirth.text.trim().isNotEmpty)
        'date_of_birth': _dateOfBirth.text.trim(),
      if (_colour.text.trim().isNotEmpty) 'colour': _colour.text.trim(),
      if (_microchipNumber.text.trim().isNotEmpty)
        'microchip_number': _microchipNumber.text.trim(),
      if (_veterinaryPractice.text.trim().isNotEmpty)
        'veterinary_practice': _veterinaryPractice.text.trim(),
      if (_medicalNotes.text.trim().isNotEmpty)
        'medical_notes': _medicalNotes.text.trim(),
      if (_behaviouralNotes.text.trim().isNotEmpty)
        'behavioural_notes': _behaviouralNotes.text.trim(),
      if (_feedingNotes.text.trim().isNotEmpty)
        'feeding_notes': _feedingNotes.text.trim(),
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
    final isEdit = widget.dog != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Dog' : 'New Dog'),
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
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
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
                controller: _breed,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _sex,
                decoration: const InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Not set')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (v) => setState(() => _sex = v ?? ''),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: _neutered,
                onChanged: (v) => setState(() => _neutered = v),
                title: const Text('Neutered'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateOfBirth,
                decoration: const InputDecoration(
                  labelText: 'Date of birth (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colour,
                decoration: const InputDecoration(
                  labelText: 'Colour',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _microchipNumber,
                decoration: const InputDecoration(
                  labelText: 'Microchip number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _veterinaryPractice,
                decoration: const InputDecoration(
                  labelText: 'Veterinary practice',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicalNotes,
                decoration: const InputDecoration(
                  labelText: 'Medical notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _behaviouralNotes,
                decoration: const InputDecoration(
                  labelText: 'Behavioural notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedingNotes,
                decoration: const InputDecoration(
                  labelText: 'Feeding notes',
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
                    : Text(isEdit ? 'Save changes' : 'Create dog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
