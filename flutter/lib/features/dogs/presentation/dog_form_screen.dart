import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cicwtch/features/breeds/data/breeds_repository.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/form_error_banner.dart';
import 'package:cicwtch/shared/presentation/section_heading.dart';

import 'dog_avatar_widget.dart';

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
  late final TextEditingController _dateOfBirth;
  late final TextEditingController _colour;
  late final TextEditingController _microchipNumber;
  late final TextEditingController _veterinaryPractice;
  late final TextEditingController _medicalNotes;
  late final TextEditingController _behaviouralNotes;
  late final TextEditingController _feedingNotes;

  String? _breedId;
  String _sex = '';
  bool _neutered = false;

  bool _submitting = false;
  String? _submitError;

  List<Breed> _breeds = [];
  bool _breedsLoading = true;

  Uint8List? _avatarBytes;
  bool _avatarUploading = false;
  Dog? _currentDog;

  @override
  void initState() {
    super.initState();
    final d = widget.dog;
    _name = TextEditingController(text: d?.name ?? '');
    _clientId = TextEditingController(text: d?.clientId ?? '');
    _breedId = d?.breedId;
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
    _currentDog = d;
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    try {
      final repo = BreedsRepository(buildApiClient());
      final breeds = await repo.listBreeds();
      if (mounted) {
        setState(() {
          _breeds = breeds;
          _breedsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _breedsLoading = false);
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final dog = _currentDog;
    if (dog == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _avatarUploading = true;
      _avatarBytes = bytes;
    });

    try {
      final service = DogsService(DogsRepository(buildApiClient()));
      final updated = await service.uploadAvatar(
        dog.id,
        fileBytes: bytes,
        filename: picked.name,
        mimeType: picked.mimeType,
      );
      if (mounted) {
        setState(() {
          _currentDog = updated;
          _avatarUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar uploaded')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _avatarUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avatar upload failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _clientId.dispose();
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
      if (_breedId != null && _breedId!.isNotEmpty) 'breed_id': _breedId,
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
    final existingBreedText = widget.dog?.breed;

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
                FormErrorBanner(message: _submitError!),
              if (isEdit) ...[
                const SectionHeading(title: 'Avatar'),
                Center(
                  child: Column(
                    children: [
                      if (_avatarBytes != null)
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: MemoryImage(_avatarBytes!),
                        )
                      else if (_currentDog != null)
                        DogAvatarWidget(dog: _currentDog!, radius: 48)
                      else
                        const CircleAvatar(
                          radius: 48,
                          child: Icon(Icons.pets, size: 48),
                        ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed:
                            _avatarUploading ? null : _pickAndUploadAvatar,
                        icon: _avatarUploading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.camera_alt),
                        label: Text(
                          _avatarUploading
                              ? 'Uploading…'
                              : 'Change avatar',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SectionHeading(title: 'Basic details'),
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
              const SizedBox(height: 24),
              const SectionHeading(title: 'Health & identity'),
              if (_breedsLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _breedId,
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    border: const OutlineInputBorder(),
                    helperText: existingBreedText != null && _breedId == null
                        ? 'Previously: $existingBreedText'
                        : null,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Not set'),
                    ),
                    ..._breeds.map(
                      (b) => DropdownMenuItem<String>(
                        value: b.breedId,
                        child: Text(b.breedName),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _breedId = v),
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
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'unknown', child: Text('Unknown')),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              const SectionHeading(title: 'Notes'),
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
