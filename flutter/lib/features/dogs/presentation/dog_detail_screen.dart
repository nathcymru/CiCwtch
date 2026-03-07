import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'dog_edit_screen.dart';

class DogDetailScreen extends StatefulWidget {
  const DogDetailScreen({super.key, required this.dogId});

  final String dogId;

  @override
  State<DogDetailScreen> createState() => _DogDetailScreenState();
}

class _DogDetailScreenState extends State<DogDetailScreen> {
  final _service = DogsService(
    DogsRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
  );

  Dog? _dog;
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
      setState(() {
        _dog = dog;
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_dog == null) return const SizedBox.shrink();

    final dog = _dog!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailRow(label: 'Name', value: dog.name),
        _DetailRow(label: 'Client ID', value: dog.clientId),
        if (dog.breed != null) _DetailRow(label: 'Breed', value: dog.breed!),
        if (dog.sex != null) _DetailRow(label: 'Sex', value: dog.sex!),
        _DetailRow(label: 'Neutered', value: dog.neutered ? 'Yes' : 'No'),
        if (dog.dateOfBirth != null)
          _DetailRow(label: 'Date of birth', value: dog.dateOfBirth!),
        if (dog.colour != null)
          _DetailRow(label: 'Colour', value: dog.colour!),
        if (dog.microchipNumber != null)
          _DetailRow(label: 'Microchip', value: dog.microchipNumber!),
        if (dog.veterinaryPractice != null)
          _DetailRow(label: 'Vet practice', value: dog.veterinaryPractice!),
        if (dog.medicalNotes != null)
          _DetailRow(label: 'Medical notes', value: dog.medicalNotes!),
        if (dog.behaviouralNotes != null)
          _DetailRow(label: 'Behavioural notes', value: dog.behaviouralNotes!),
        if (dog.feedingNotes != null)
          _DetailRow(label: 'Feeding notes', value: dog.feedingNotes!),
        const Divider(height: 32),
        _DetailRow(label: 'Created', value: _formatDate(dog.createdAt)),
        _DetailRow(label: 'Updated', value: _formatDate(dog.updatedAt)),
      ],
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
