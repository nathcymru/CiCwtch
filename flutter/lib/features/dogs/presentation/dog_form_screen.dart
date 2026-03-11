import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cicwtch/features/breeds/data/breeds_repository.dart';
import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/features/vet_practices/data/vet_practices_repository.dart';
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
  static const _stepLabels = ['Identity', 'Health', 'Behaviour', 'Logistics'];

  int _currentStep = 0;
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  // ── Step 1 — Identity ──────────────────────────────────────────────
  late final TextEditingController _name;
  late final TextEditingController _clientId;
  late final TextEditingController _dateOfBirth;
  late final TextEditingController _colour;
  late final TextEditingController _microchipNumber;

  String? _breedId;
  String _sex = '';

  // ── Step 2 — Health ────────────────────────────────────────────────
  bool _neutered = false;
  bool _allergies = false;
  late final TextEditingController _allergiesNotes;
  bool _medication = false;
  late final TextEditingController _medicationNotes;
  String? _vetPracticeId;
  late final TextEditingController _veterinaryPractice;
  late final TextEditingController _medicalNotes;
  late final TextEditingController _feedingNotes;

  // ── Step 3 — Behaviour ─────────────────────────────────────────────
  String? _energyLevel;
  String? _leashManners;
  String? _recallRating;
  bool _aggressive = false;
  bool _muzzleRequired = false;
  late final TextEditingController _specialCommands;
  late final TextEditingController _behaviouralNotes;

  // ── Step 4 — Logistics ─────────────────────────────────────────────
  late final TextEditingController _gearLocation;

  // ── Common state ───────────────────────────────────────────────────
  bool _submitting = false;
  String? _submitError;

  List<Breed> _breeds = [];
  bool _breedsLoading = true;

  List<VeterinaryPractice> _vetPractices = [];
  bool _vetPracticesLoading = true;

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
    _sex = d?.sex ?? '';

    _neutered = d?.neutered ?? false;
    _allergies = d?.allergies ?? false;
    _allergiesNotes = TextEditingController(text: d?.allergiesNotes ?? '');
    _medication = d?.medication ?? false;
    _medicationNotes = TextEditingController(text: d?.medicationNotes ?? '');
    _vetPracticeId = d?.vetPracticeId;
    _veterinaryPractice =
        TextEditingController(text: d?.veterinaryPractice ?? '');
    _medicalNotes = TextEditingController(text: d?.medicalNotes ?? '');
    _feedingNotes = TextEditingController(text: d?.feedingNotes ?? '');

    _energyLevel = d?.energyLevel;
    _leashManners = d?.leashManners;
    _recallRating = d?.recallRating;
    _aggressive = d?.aggressive ?? false;
    _muzzleRequired = d?.muzzleRequired ?? false;
    _specialCommands = TextEditingController(text: d?.specialCommands ?? '');
    _behaviouralNotes =
        TextEditingController(text: d?.behaviouralNotes ?? '');

    _gearLocation = TextEditingController(text: d?.gearLocation ?? '');

    _currentDog = d;
    _loadBreeds();
    _loadVetPractices();
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
      if (mounted) setState(() => _breedsLoading = false);
    }
  }

  Future<void> _loadVetPractices() async {
    try {
      final repo = VetPracticesRepository(buildApiClient());
      final practices = await repo.listVetPractices();
      if (mounted) {
        setState(() {
          _vetPractices = practices;
          _vetPracticesLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _vetPracticesLoading = false);
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
    _allergiesNotes.dispose();
    _medicationNotes.dispose();
    _specialCommands.dispose();
    _gearLocation.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    return _formKeys[_currentStep].currentState?.validate() ?? false;
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    setState(() => _currentStep++);
  }

  void _previousStep() {
    setState(() => _currentStep--);
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;

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
      'allergies': _allergies ? 1 : 0,
      if (_allergiesNotes.text.trim().isNotEmpty)
        'allergies_notes': _allergiesNotes.text.trim(),
      'medication': _medication ? 1 : 0,
      if (_medicationNotes.text.trim().isNotEmpty)
        'medication_notes': _medicationNotes.text.trim(),
      if (_vetPracticeId != null && _vetPracticeId!.isNotEmpty)
        'vet_practice_id': _vetPracticeId,
      if (_energyLevel != null && _energyLevel!.isNotEmpty)
        'energy_level': _energyLevel,
      if (_leashManners != null && _leashManners!.isNotEmpty)
        'leash_manners': _leashManners,
      if (_recallRating != null && _recallRating!.isNotEmpty)
        'recall_rating': _recallRating,
      'aggressive': _aggressive ? 1 : 0,
      'muzzle_required': _muzzleRequired ? 1 : 0,
      if (_specialCommands.text.trim().isNotEmpty)
        'special_commands': _specialCommands.text.trim(),
      if (_gearLocation.text.trim().isNotEmpty)
        'gear_location': _gearLocation.text.trim(),
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

  // ── Step builders ──────────────────────────────────────────────────

  Widget _buildStep1Identity() {
    final isEdit = widget.dog != null;
    final existingBreedText = widget.dog?.breed;

    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                      _avatarUploading ? 'Uploading…' : 'Change avatar',
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
              labelText: 'Dog name *',
              border: OutlineInputBorder(),
              helperText: 'The name the dog responds to',
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Dog name is required'
                : null,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _clientId,
            decoration: const InputDecoration(
              labelText: 'Client ID *',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Client ID is required'
                : null,
          ),
          const SizedBox(height: 24),
          const SectionHeading(title: 'Breed & appearance'),
          if (_breedsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            DropdownButtonFormField<String>(
              value: _breedId,
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
            value: _sex,
            decoration: const InputDecoration(
              labelText: 'Gender',
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateOfBirth,
            decoration: const InputDecoration(
              labelText: 'Date of birth (YYYY-MM-DD)',
              border: OutlineInputBorder(),
              helperText: 'Approximate date is fine',
            ),
            keyboardType: TextInputType.datetime,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              final parsed = DateTime.tryParse(v.trim());
              if (parsed == null) return 'Use YYYY-MM-DD format';
              if (parsed.isAfter(DateTime.now())) {
                return 'Birth date cannot be in the future';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _colour,
            decoration: const InputDecoration(
              labelText: 'Colour / markings',
              border: OutlineInputBorder(),
              helperText: 'e.g. Black and white, Tri-colour',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _microchipNumber,
            decoration: const InputDecoration(
              labelText: 'Microchip number',
              border: OutlineInputBorder(),
              helperText: 'UK standard is 15 digits',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (v.trim().length != 15) {
                return 'Microchip number should be 15 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Health() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(title: 'Spay / neuter status'),
          SwitchListTile(
            value: _neutered,
            onChanged: (v) => setState(() => _neutered = v),
            title: const Text('Spayed / neutered'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          const SectionHeading(title: 'Allergies'),
          SwitchListTile(
            value: _allergies,
            onChanged: (v) => setState(() => _allergies = v),
            title: const Text('Has known allergies'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_allergies) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _allergiesNotes,
              decoration: const InputDecoration(
                labelText: 'Allergy details',
                border: OutlineInputBorder(),
                helperText: 'e.g. Chicken, grass, flea treatments',
              ),
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 16),
          const SectionHeading(title: 'Medication'),
          SwitchListTile(
            value: _medication,
            onChanged: (v) => setState(() => _medication = v),
            title: const Text('On current medication'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_medication) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _medicationNotes,
              decoration: const InputDecoration(
                labelText: 'Medication details',
                border: OutlineInputBorder(),
                helperText: 'Name, dosage, and schedule',
              ),
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 16),
          const SectionHeading(title: 'Veterinary contact'),
          if (_vetPracticesLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            DropdownButtonFormField<String>(
              value: _vetPracticeId,
              decoration: const InputDecoration(
                labelText: 'Veterinary practice',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Not set'),
                ),
                ..._vetPractices.map(
                  (vp) => DropdownMenuItem<String>(
                    value: vp.id,
                    child: Text(vp.name),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _vetPracticeId = v),
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _veterinaryPractice,
            decoration: const InputDecoration(
              labelText: 'Vet practice (free text)',
              border: OutlineInputBorder(),
              helperText: 'Use if practice is not in the dropdown above',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          const SectionHeading(title: 'Medical & feeding notes'),
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
            controller: _feedingNotes,
            decoration: const InputDecoration(
              labelText: 'Feeding notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Behaviour() {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(title: 'Temperament ratings'),
          DropdownButtonFormField<String>(
            value: _energyLevel,
            decoration: const InputDecoration(
              labelText: 'Energy level',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Not set')),
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'medium', child: Text('Medium')),
              DropdownMenuItem(value: 'high', child: Text('High')),
            ],
            onChanged: (v) => setState(() => _energyLevel = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _leashManners,
            decoration: const InputDecoration(
              labelText: 'Leash manners',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Not set')),
              DropdownMenuItem(value: 'poor', child: Text('Poor')),
              DropdownMenuItem(value: 'fair', child: Text('Fair')),
              DropdownMenuItem(value: 'good', child: Text('Good')),
              DropdownMenuItem(value: 'excellent', child: Text('Excellent')),
            ],
            onChanged: (v) => setState(() => _leashManners = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _recallRating,
            decoration: const InputDecoration(
              labelText: 'Recall',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Not set')),
              DropdownMenuItem(value: 'poor', child: Text('Poor')),
              DropdownMenuItem(value: 'fair', child: Text('Fair')),
              DropdownMenuItem(value: 'good', child: Text('Good')),
              DropdownMenuItem(value: 'excellent', child: Text('Excellent')),
            ],
            onChanged: (v) => setState(() => _recallRating = v),
          ),
          const SizedBox(height: 24),
          const SectionHeading(title: 'Safety flags'),
          SwitchListTile(
            value: _aggressive,
            onChanged: (v) {
              setState(() {
                _aggressive = v;
                if (!v) _muzzleRequired = false;
              });
            },
            title: const Text('Aggressive tendencies'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_aggressive)
            SwitchListTile(
              value: _muzzleRequired,
              onChanged: (v) => setState(() => _muzzleRequired = v),
              title: const Text('Muzzle required'),
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _specialCommands,
            decoration: const InputDecoration(
              labelText: 'Special commands',
              border: OutlineInputBorder(),
              helperText: 'e.g. "aros" (wait in Welsh), hand signals',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          const SectionHeading(title: 'Behavioural notes'),
          TextFormField(
            controller: _behaviouralNotes,
            decoration: const InputDecoration(
              labelText: 'Behavioural notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Logistics() {
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(title: 'Walking gear'),
          TextFormField(
            controller: _gearLocation,
            decoration: const InputDecoration(
              labelText: 'Gear location',
              border: OutlineInputBorder(),
              helperText: 'e.g. Hooks by back door, basket in hallway',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.dog != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Dog' : 'New Dog'),
      ),
      body: Column(
        children: [
          // ── Progress indicator ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_stepLabels.length, (i) {
                final isActive = i == _currentStep;
                final isDone = i < _currentStep;
                return Expanded(
                  child: GestureDetector(
                    onTap: i < _currentStep
                        ? () => setState(() => _currentStep = i)
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: isDone
                              ? Theme.of(context).colorScheme.primary
                              : isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                          child: isDone
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isActive
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _stepLabels[i],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1),

          // ── Form content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_submitError != null)
                    FormErrorBanner(message: _submitError!),
                  if (_currentStep == 0) _buildStep1Identity(),
                  if (_currentStep == 1) _buildStep2Health(),
                  if (_currentStep == 2) _buildStep3Behaviour(),
                  if (_currentStep == 3) _buildStep4Logistics(),
                ],
              ),
            ),
          ),

          // ── Bottom navigation ──────────────────────────────────────
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  if (_currentStep < _stepLabels.length - 1)
                    FilledButton(
                      onPressed: _nextStep,
                      child: const Text('Next'),
                    )
                  else
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEdit ? 'Save changes' : 'Create dog'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
