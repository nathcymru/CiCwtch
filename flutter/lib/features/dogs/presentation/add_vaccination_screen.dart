import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';

class AddVaccinationScreen extends StatefulWidget {
  const AddVaccinationScreen({super.key, required this.dogId});

  final String dogId;

  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final _service = DogsService(DogsRepository(buildApiClient()));
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateAdministeredController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _documentKeyController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dateAdministeredController.dispose();
    _expirationDateController.dispose();
    _documentKeyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final payload = <String, dynamic>{
      'vaccination_name': _nameController.text.trim(),
      'date_administered': _dateAdministeredController.text.trim(),
    };

    final expiration = _expirationDateController.text.trim();
    if (expiration.isNotEmpty) {
      payload['expiration_date'] = expiration;
    }

    final docKey = _documentKeyController.text.trim();
    if (docKey.isNotEmpty) {
      payload['document_object_key'] = docKey;
    }

    try {
      await _service.createVaccination(widget.dogId, payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vaccination')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Vaccination name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateAdministeredController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date administered',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(_dateAdministeredController),
                ),
              ),
              onTap: () => _pickDate(_dateAdministeredController),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expirationDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Expiration date (optional)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(_expirationDateController),
                ),
              ),
              onTap: () => _pickDate(_expirationDateController),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _documentKeyController,
              decoration: const InputDecoration(
                labelText: 'Document object key (optional)',
                border: OutlineInputBorder(),
                helperText: 'R2 object key for supporting document',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save vaccination'),
            ),
          ],
        ),
      ),
    );
  }
}
