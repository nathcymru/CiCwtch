import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';

class AddBehaviorSnapshotScreen extends StatefulWidget {
  const AddBehaviorSnapshotScreen({super.key, required this.dogId});

  final String dogId;

  @override
  State<AddBehaviorSnapshotScreen> createState() =>
      _AddBehaviorSnapshotScreenState();
}

class _AddBehaviorSnapshotScreenState extends State<AddBehaviorSnapshotScreen> {
  final _service = DogsService(DogsRepository(buildApiClient()));
  final _notesController = TextEditingController();

  int? _recallRating;
  int? _leashMannersRating;
  int? _energyLevelRating;
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final payload = <String, dynamic>{};
    if (_recallRating != null) payload['recall_rating'] = _recallRating;
    if (_leashMannersRating != null) {
      payload['leash_manners_rating'] = _leashMannersRating;
    }
    if (_energyLevelRating != null) {
      payload['energy_level_rating'] = _energyLevelRating;
    }
    final notes = _notesController.text.trim();
    if (notes.isNotEmpty) payload['notes'] = notes;

    try {
      await _service.createBehaviorSnapshot(widget.dogId, payload);
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
      appBar: AppBar(title: const Text('Add Behaviour Snapshot')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RatingField(
            label: 'Recall',
            value: _recallRating,
            onChanged: (v) => setState(() => _recallRating = v),
          ),
          const SizedBox(height: 16),
          _RatingField(
            label: 'Leash manners',
            value: _leashMannersRating,
            onChanged: (v) => setState(() => _leashMannersRating = v),
          ),
          const SizedBox(height: 16),
          _RatingField(
            label: 'Energy level',
            value: _energyLevelRating,
            onChanged: (v) => setState(() => _energyLevelRating = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
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
                : const Text('Save snapshot'),
          ),
        ],
      ),
    );
  }
}

class _RatingField extends StatelessWidget {
  const _RatingField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        SegmentedButton<int?>(
          segments: const [
            ButtonSegment(value: 1, label: Text('1')),
            ButtonSegment(value: 2, label: Text('2')),
            ButtonSegment(value: 3, label: Text('3')),
            ButtonSegment(value: 4, label: Text('4')),
            ButtonSegment(value: 5, label: Text('5')),
          ],
          selected: value != null ? {value} : {},
          emptySelectionAllowed: true,
          onSelectionChanged: (sel) => onChanged(sel.isEmpty ? null : sel.first),
        ),
      ],
    );
  }
}
