import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cicwtch/features/breeds/data/breeds_repository.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
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
  final Future<Dog> Function(Map<String, dynamic> payload) onSubmit;

  @override
  State<DogFormScreen> createState() => _DogFormScreenState();
}

class _DogFormScreenState extends State<DogFormScreen> {
  static const _stepLabels = ['Identity', 'Health', 'Behaviour', 'Logistics'];

  int _currentStep = 0;
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  // ── Step 1 — Identity ──────────────────────────────────────────────
  late final TextEditingController _name;
  String? _selectedClientId;
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
  bool _hasMedicalConditions = false;
  late final TextEditingController _medicalConditionNotes;

  // ── Step 3 — Behaviour ─────────────────────────────────────────────
  bool _hasBiteHistory = false;
  late final TextEditingController _biteHistoryDetails;
  bool _hasSevereReactivity = false;
  late final TextEditingController _severeReactivityDetails;
  bool _hasEscapeArtist = false;
  late final TextEditingController _escapeArtistDetails;
  bool _hasResourceGuarding = false;
  late final TextEditingController _resourceGuardingDetails;

  bool _hasSpecialCommands = false;
  late final TextEditingController _specialCommands;

  double _recallSlider = 3;
  double _leashMannersSlider = 3;
  double _energyLevelSlider = 3;

  // ── Step 4 — Logistics ─────────────────────────────────────────────
  late final TextEditingController _gearLocation;

  // ── Common state ───────────────────────────────────────────────────
  bool _submitting = false;
  String? _submitError;

  List<Breed> _breeds = [];
  bool _breedsLoading = true;

  List<Client> _clients = [];
  bool _clientsLoading = true;

  List<VeterinaryPractice> _vetPractices = [];
  bool _vetPracticesLoading = true;

  Uint8List? _avatarBytes;
  String? _avatarFilename;
  bool _avatarUploading = false;
  Uint8List? _nosePhotoBytes;
  Uint8List? _walkingGearPhotoBytes;
  Dog? _currentDog;

  @override
  void initState() {
    super.initState();
    final d = widget.dog;
    _name = TextEditingController(text: d?.name ?? '');
    _selectedClientId = d?.clientId;
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
    _hasMedicalConditions = (d?.medicalNotes ?? '').isNotEmpty;
    _medicalConditionNotes =
        TextEditingController(text: d?.medicalNotes ?? '');

    _hasBiteHistory = false;
    _biteHistoryDetails = TextEditingController();
    _hasSevereReactivity = false;
    _severeReactivityDetails = TextEditingController();
    _hasEscapeArtist = false;
    _escapeArtistDetails = TextEditingController();
    _hasResourceGuarding = false;
    _resourceGuardingDetails = TextEditingController();

    _hasSpecialCommands = (d?.specialCommands ?? '').isNotEmpty;
    _specialCommands = TextEditingController(text: d?.specialCommands ?? '');

    _recallSlider = 3;
    _leashMannersSlider = 3;
    _energyLevelSlider = 3;

    _gearLocation = TextEditingController(text: d?.gearLocation ?? '');

    _currentDog = d;
    _loadBreeds();
    _loadClients();
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

  Future<void> _loadClients() async {
    try {
      final repo = ClientsRepository(buildApiClient());
      final clients = await repo.listClients();
      if (mounted) {
        setState(() {
          _clients = clients;
          _clientsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _clientsLoading = false);
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

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    // In edit mode, upload immediately
    final dog = _currentDog;
    if (dog != null) {
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
    } else {
      // In create mode, store bytes locally for upload after creation
      setState(() {
        _avatarBytes = bytes;
        _avatarFilename = picked.name;
      });
    }
  }

  Future<void> _pickNosePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _nosePhotoBytes = bytes);
  }

  Future<void> _pickWalkingGearPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _walkingGearPhotoBytes = bytes);
  }

  @override
  void dispose() {
    _name.dispose();
    _dateOfBirth.dispose();
    _colour.dispose();
    _microchipNumber.dispose();
    _allergiesNotes.dispose();
    _medicationNotes.dispose();
    _medicalConditionNotes.dispose();
    _biteHistoryDetails.dispose();
    _severeReactivityDetails.dispose();
    _escapeArtistDetails.dispose();
    _resourceGuardingDetails.dispose();
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

  String _buildBehaviouralNotes() {
    final parts = <String>[];
    if (_hasBiteHistory) {
      final detail = _biteHistoryDetails.text.trim();
      parts.add(detail.isNotEmpty
          ? 'Bite history: $detail'
          : 'Bite history: Yes');
    }
    if (_hasSevereReactivity) {
      final detail = _severeReactivityDetails.text.trim();
      parts.add(detail.isNotEmpty
          ? 'Severe reactivity: $detail'
          : 'Severe reactivity: Yes');
    }
    if (_hasEscapeArtist) {
      final detail = _escapeArtistDetails.text.trim();
      parts.add(detail.isNotEmpty
          ? 'Escape artist: $detail'
          : 'Escape artist: Yes');
    }
    if (_hasResourceGuarding) {
      final detail = _resourceGuardingDetails.text.trim();
      parts.add(detail.isNotEmpty
          ? 'Resource guarding: $detail'
          : 'Resource guarding: Yes');
    }
    return parts.join('\n');
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final behaviouralNotes = _buildBehaviouralNotes();
    final hasAnyRedFlag = _hasBiteHistory ||
        _hasSevereReactivity ||
        _hasEscapeArtist ||
        _hasResourceGuarding;

    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      'client_id': _selectedClientId ?? '',
      'neutered': _neutered ? 1 : 0,
      if (_breedId != null && _breedId!.isNotEmpty) 'breed_id': _breedId,
      if (_sex.isNotEmpty) 'sex': _sex,
      if (_dateOfBirth.text.trim().isNotEmpty)
        'date_of_birth': _dateOfBirth.text.trim(),
      if (_colour.text.trim().isNotEmpty) 'colour': _colour.text.trim(),
      if (_microchipNumber.text.trim().isNotEmpty)
        'microchip_number': _microchipNumber.text.trim(),
      if (_hasMedicalConditions &&
          _medicalConditionNotes.text.trim().isNotEmpty)
        'medical_notes': _medicalConditionNotes.text.trim(),
      if (behaviouralNotes.isNotEmpty) 'behavioural_notes': behaviouralNotes,
      'allergies': _allergies ? 1 : 0,
      if (_allergiesNotes.text.trim().isNotEmpty)
        'allergies_notes': _allergiesNotes.text.trim(),
      'medication': _medication ? 1 : 0,
      if (_medicationNotes.text.trim().isNotEmpty)
        'medication_notes': _medicationNotes.text.trim(),
      if (_vetPracticeId != null && _vetPracticeId!.isNotEmpty)
        'vet_practice_id': _vetPracticeId,
      'aggressive': hasAnyRedFlag ? 1 : 0,
      'muzzle_required': 0,
      if (_hasSpecialCommands && _specialCommands.text.trim().isNotEmpty)
        'special_commands': _specialCommands.text.trim(),
      if (_gearLocation.text.trim().isNotEmpty)
        'gear_location': _gearLocation.text.trim(),
    };

    try {
      final result = await widget.onSubmit(payload);

      // Post-creation tasks
      if (widget.dog == null) {
        final service = DogsService(DogsRepository(buildApiClient()));

        // Upload avatar if selected during creation
        if (_avatarBytes != null) {
          try {
            await service.uploadAvatar(
              result.id,
              fileBytes: _avatarBytes!,
              filename: _avatarFilename ?? 'avatar.jpg',
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Avatar upload failed: $e')),
              );
            }
          }
        }

        // Create initial behaviour snapshot
        final snapshotPayload = <String, dynamic>{
          'recall_rating': _recallSlider.round(),
          'leash_manners_rating': _leashMannersSlider.round(),
          'energy_level_rating': _energyLevelSlider.round(),
        };
        try {
          await service.createBehaviorSnapshot(result.id, snapshotPayload);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Behaviour snapshot failed: $e'),
              ),
            );
          }
        }
      }

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
          // ── Avatar photo ───────────────────────────────────────────
          const SectionHeading(title: 'Avatar'),
          Center(
            child: Column(
              children: [
                if (_avatarBytes != null)
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: MemoryImage(_avatarBytes!),
                  )
                else if (isEdit && _currentDog != null)
                  DogAvatarWidget(dog: _currentDog!, radius: 48)
                else
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.pets, size: 48),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _avatarUploading ? null : _pickAvatar,
                  icon: _avatarUploading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(
                    _avatarUploading
                        ? 'Uploading…'
                        : _avatarBytes != null
                            ? 'Change avatar'
                            : 'Add avatar',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Nose photo ─────────────────────────────────────────────
          const SectionHeading(title: 'Nose photo'),
          Center(
            child: Column(
              children: [
                if (_nosePhotoBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _nosePhotoBytes!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fingerprint, size: 48),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pickNosePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    _nosePhotoBytes != null
                        ? 'Change nose photo'
                        : 'Add nose photo',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Basic details ──────────────────────────────────────────
          const SectionHeading(title: 'Basic details'),
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Dog name *',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Dog name is required'
                : null,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // ── Client selector (fuzzy search) ─────────────────────────
          if (_clientsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Autocomplete<Client>(
              initialValue: TextEditingValue(
                text: _getClientDisplayName(_selectedClientId),
              ),
              displayStringForOption: (c) => c.fullName,
              optionsBuilder: (textEditingValue) {
                final q = textEditingValue.text.toLowerCase();
                if (q.isEmpty) return _clients;
                return _clients.where(
                  (c) =>
                      c.fullName.toLowerCase().contains(q) ||
                      (c.preferredName?.toLowerCase().contains(q) ?? false),
                );
              },
              onSelected: (c) =>
                  setState(() => _selectedClientId = c.id),
              fieldViewBuilder:
                  (ctx, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Client *',
                    border: const OutlineInputBorder(),
                    suffixIcon: _selectedClientId != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              setState(() => _selectedClientId = null);
                            },
                          )
                        : null,
                  ),
                  validator: (_) => _selectedClientId == null
                      ? 'Client is required'
                      : null,
                );
              },
            ),
          const SizedBox(height: 24),

          // ── Breed & appearance ─────────────────────────────────────
          const SectionHeading(title: 'Breed & appearance'),
          if (_breedsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Autocomplete<Breed>(
              initialValue: TextEditingValue(
                text: _getBreedDisplayName(_breedId),
              ),
              displayStringForOption: (b) => b.breedName,
              optionsBuilder: (textEditingValue) {
                final q = textEditingValue.text.toLowerCase();
                if (q.isEmpty) return _breeds;
                return _breeds.where(
                  (b) => b.breedName.toLowerCase().contains(q),
                );
              },
              onSelected: (b) =>
                  setState(() => _breedId = b.breedId),
              fieldViewBuilder:
                  (ctx, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    border: const OutlineInputBorder(),
                    helperText:
                        existingBreedText != null && _breedId == null
                            ? 'Previously: $existingBreedText'
                            : null,
                    suffixIcon: _breedId != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              setState(() => _breedId = null);
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _sex,
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
          const SectionHeading(title: 'Vet'),
          if (_vetPracticesLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Autocomplete<VeterinaryPractice>(
              initialValue: TextEditingValue(
                text: _getVetDisplayName(_vetPracticeId),
              ),
              displayStringForOption: (vp) => vp.name,
              optionsBuilder: (textEditingValue) {
                final q = textEditingValue.text.toLowerCase();
                if (q.isEmpty) return _vetPractices;
                return _vetPractices.where(
                  (vp) => vp.name.toLowerCase().contains(q),
                );
              },
              onSelected: (vp) =>
                  setState(() => _vetPracticeId = vp.id),
              fieldViewBuilder:
                  (ctx, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Vet practice',
                    border: const OutlineInputBorder(),
                    suffixIcon: _vetPracticeId != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                              setState(() => _vetPracticeId = null);
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          const SectionHeading(title: 'Medical conditions'),
          SwitchListTile(
            value: _hasMedicalConditions,
            onChanged: (v) => setState(() => _hasMedicalConditions = v),
            title: const Text(
              'Does the dog have any medical conditions relevant to walks?',
            ),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasMedicalConditions) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _medicalConditionNotes,
              decoration: const InputDecoration(
                labelText: 'Medical condition details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
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
          // ── Red flags ──────────────────────────────────────────────
          const SectionHeading(title: 'Red flags'),

          // Bite History
          SwitchListTile(
            value: _hasBiteHistory,
            onChanged: (v) => setState(() => _hasBiteHistory = v),
            title: const Text(
              'Has the dog ever bitten a person or another animal?',
            ),
            subtitle: const Text('Bite history'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasBiteHistory) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _biteHistoryDetails,
              decoration: const InputDecoration(
                labelText: 'Further details (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 8),

          // Severe Reactivity
          SwitchListTile(
            value: _hasSevereReactivity,
            onChanged: (v) => setState(() => _hasSevereReactivity = v),
            title: const Text(
              'Does the dog lunge or snap at cars, bikes, or people?',
            ),
            subtitle: const Text('Severe reactivity'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasSevereReactivity) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _severeReactivityDetails,
              decoration: const InputDecoration(
                labelText: 'Further details (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 8),

          // Escape Artist
          SwitchListTile(
            value: _hasEscapeArtist,
            onChanged: (v) => setState(() => _hasEscapeArtist = v),
            title: const Text(
              'Has the dog ever slipped their collar or jumped a fence?',
            ),
            subtitle: const Text('Escape artist'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasEscapeArtist) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _escapeArtistDetails,
              decoration: const InputDecoration(
                labelText: 'Further details (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 8),

          // Resource Guarding
          SwitchListTile(
            value: _hasResourceGuarding,
            onChanged: (v) => setState(() => _hasResourceGuarding = v),
            title: const Text(
              'Does the dog growl or snap if you try to touch their leash, harness, or "treasures"?',
            ),
            subtitle: const Text('Resource guarding'),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasResourceGuarding) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _resourceGuardingDetails,
              decoration: const InputDecoration(
                labelText: 'Further details (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 24),

          // ── Temperament ────────────────────────────────────────────
          const SectionHeading(title: 'Temperament'),

          // Special Commands toggle
          SwitchListTile(
            value: _hasSpecialCommands,
            onChanged: (v) => setState(() => _hasSpecialCommands = v),
            title: const Text('Does the dog have any special commands?'),
            subtitle: const Text(
              'e.g. Only woofs in Welsh\nStay: Aros!\nLie down: Gorwedd!',
            ),
            contentPadding: EdgeInsets.zero,
          ),
          if (_hasSpecialCommands) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _specialCommands,
              decoration: const InputDecoration(
                labelText: 'Special commands',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 24),

          // ── Behaviour ratings (sliders) ────────────────────────────
          const SectionHeading(title: 'Behaviour ratings'),

          // Recall slider
          const Text('Recall'),
          Row(
            children: [
              const Text('1 — Ghosting 👻'),
              Expanded(
                child: Slider(
                  value: _recallSlider,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _recallSlider.round().toString(),
                  onChanged: (v) => setState(() => _recallSlider = v),
                ),
              ),
              const Text('5 — Boomerang 🪃'),
            ],
          ),
          const SizedBox(height: 16),

          // Leash Manners slider
          const Text('Leash Manners'),
          Row(
            children: [
              const Text('1 — Sled Dog 🛷'),
              Expanded(
                child: Slider(
                  value: _leashMannersSlider,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _leashMannersSlider.round().toString(),
                  onChanged: (v) =>
                      setState(() => _leashMannersSlider = v),
                ),
              ),
              const Text('5 — Glue 🧴'),
            ],
          ),
          const SizedBox(height: 16),

          // Energy Level slider
          const Text('Energy Level'),
          Row(
            children: [
              const Text('1 — Couch Potato 🥔'),
              Expanded(
                child: Slider(
                  value: _energyLevelSlider,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _energyLevelSlider.round().toString(),
                  onChanged: (v) =>
                      setState(() => _energyLevelSlider = v),
                ),
              ),
              const Text('5 — Firecracker 🧨'),
            ],
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
          const SizedBox(height: 24),

          // ── Walking gear photo ─────────────────────────────────────
          const SectionHeading(title: 'Walking gear photo'),
          Center(
            child: Column(
              children: [
                if (_walkingGearPhotoBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _walkingGearPhotoBytes!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.checkroom, size: 64),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pickWalkingGearPhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    _walkingGearPhotoBytes != null
                        ? 'Change walking gear photo'
                        : 'Add walking gear photo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────

  String _getClientDisplayName(String? clientId) {
    if (clientId == null) return '';
    for (final c in _clients) {
      if (c.id == clientId) return c.fullName;
    }
    return '';
  }

  String _getBreedDisplayName(String? breedId) {
    if (breedId == null) return '';
    for (final b in _breeds) {
      if (b.breedId == breedId) return b.breedName;
    }
    return '';
  }

  String _getVetDisplayName(String? vetPracticeId) {
    if (vetPracticeId == null) return '';
    for (final vp in _vetPractices) {
      if (vp.id == vetPracticeId) return vp.name;
    }
    return '';
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
