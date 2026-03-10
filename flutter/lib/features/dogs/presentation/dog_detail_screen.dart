import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';
import 'package:cicwtch/shared/presentation/detail_row.dart';
import 'package:cicwtch/shared/presentation/error_state_block.dart';
import 'package:cicwtch/shared/presentation/form_date_helper.dart';
import 'package:cicwtch/shared/presentation/section_heading.dart';

import 'add_behavior_snapshot_screen.dart';
import 'add_vaccination_screen.dart';
import 'dog_avatar_widget.dart';
import 'dog_edit_screen.dart';

class DogDetailScreen extends StatefulWidget {
  const DogDetailScreen({super.key, required this.dogId});

  final String dogId;

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
  final _service = DogsService(
    DogsRepository(buildApiClient()),
  );

  Dog? _dog;
  BehaviorSnapshot? _latestSnapshot;
  List<Vaccination> _vaccinations = [];
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
      final dog = await _service.getDog(widget.dogId);
      BehaviorSnapshot? snapshot;
      try {
        final snapshots =
            await _service.listBehaviorSnapshots(widget.dogId);
        if (snapshots.isNotEmpty) snapshot = snapshots.first;
      } catch (_) {
        // Snapshot load failure is non-fatal
      }
      List<Vaccination> vaccinations = [];
      try {
        vaccinations = await _service.listVaccinations(widget.dogId);
      } catch (_) {
        // Vaccination load failure is non-fatal
      }
      setState(() {
        _dog = dog;
        _latestSnapshot = snapshot;
        _vaccinations = vaccinations;
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
        title: const Text('Archive dog?'),
        content: const Text('This will archive the dog.'),
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
      await _service.deleteDog(widget.dogId);
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
    final title = _dog?.name ?? 'Dog';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _dog == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DogEditScreen(dog: _dog!),
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

    if (_dog == null) return const SizedBox.shrink();

    final dog = _dog!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: DogAvatarWidget(dog: dog, radius: 48)),
        const SizedBox(height: 16),
        DetailRow(label: 'Name', value: dog.name),
        DetailRow(label: 'Client ID', value: dog.clientId),
        if (dog.breed != null || dog.breedName != null)
          DetailRow(label: 'Breed', value: dog.breedName ?? dog.breed ?? ''),
        if (dog.sex != null) DetailRow(label: 'Sex', value: dog.sex!),
        DetailRow(label: 'Neutered', value: dog.neutered ? 'Yes' : 'No'),
        if (dog.dateOfBirth != null)
          DetailRow(label: 'Date of birth', value: dog.dateOfBirth!),
        if (dog.colour != null)
          DetailRow(label: 'Colour', value: dog.colour!),
        if (dog.microchipNumber != null)
          DetailRow(label: 'Microchip', value: dog.microchipNumber!),
        if (dog.veterinaryPractice != null)
          DetailRow(label: 'Vet practice', value: dog.veterinaryPractice!),
        if (dog.medicalNotes != null)
          DetailRow(label: 'Medical notes', value: dog.medicalNotes!),
        if (dog.behaviouralNotes != null)
          DetailRow(label: 'Behavioural notes', value: dog.behaviouralNotes!),
        if (dog.feedingNotes != null)
          DetailRow(label: 'Feeding notes', value: dog.feedingNotes!),
        const Divider(height: 32),
        _buildSnapshotSection(),
        const Divider(height: 32),
        _buildVaccinationSection(),
        const Divider(height: 32),
        DetailRow(label: 'Created', value: formatDetailDate(dog.createdAt)),
        DetailRow(label: 'Updated', value: formatDetailDate(dog.updatedAt)),
      ],
    );
  }

  Widget _buildSnapshotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeading(title: 'Latest behaviour snapshot'),
            TextButton.icon(
              onPressed: () async {
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddBehaviorSnapshotScreen(dogId: widget.dogId),
                  ),
                );
                if (added == true) _load();
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        if (_latestSnapshot == null)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('No behaviour snapshots recorded yet.'),
          )
        else ...[
          DetailRow(
            label: 'Recorded',
            value: formatDetailDate(_latestSnapshot!.createdAt),
          ),
          if (_latestSnapshot!.recallRating != null)
            DetailRow(
              label: 'Recall',
              value: '${_latestSnapshot!.recallRating} / 5',
            ),
          if (_latestSnapshot!.leashMannersRating != null)
            DetailRow(
              label: 'Leash manners',
              value: '${_latestSnapshot!.leashMannersRating} / 5',
            ),
          if (_latestSnapshot!.energyLevelRating != null)
            DetailRow(
              label: 'Energy level',
              value: '${_latestSnapshot!.energyLevelRating} / 5',
            ),
          if (_latestSnapshot!.notes != null &&
              _latestSnapshot!.notes!.isNotEmpty)
            DetailRow(label: 'Notes', value: _latestSnapshot!.notes!),
        ],
      ],
    );
  }

  Widget _buildVaccinationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeading(title: 'Vaccinations'),
            TextButton.icon(
              onPressed: () async {
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddVaccinationScreen(dogId: widget.dogId),
                  ),
                );
                if (added == true) _load();
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        if (_vaccinations.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('No vaccinations recorded yet.'),
          )
        else
          ..._vaccinations.map((v) => Card(
                child: ListTile(
                  title: Text(v.vaccinationName),
                  subtitle: Text(
                    'Administered: ${formatDetailDate(v.dateAdministered)}'
                    '${v.expirationDate != null ? '\nExpires: ${formatDetailDate(v.expirationDate!)}' : ''}',
                  ),
                  trailing: v.documentObjectKey != null
                      ? const Icon(Icons.attach_file, size: 18)
                      : null,
                ),
              )),
      ],
    );
  }
}
