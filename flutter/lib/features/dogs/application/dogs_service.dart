import 'dart:typed_data';

import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class DogsService {
  DogsService(this._repository);

  final DogsRepository _repository;

  Future<List<Dog>> listDogs() => _repository.listDogs();
  Future<Dog> getDog(String id) => _repository.getDog(id);
  Future<Dog> createDog(Map<String, dynamic> payload) =>
      _repository.createDog(payload);
  Future<Dog> updateDog(String id, Map<String, dynamic> payload) =>
      _repository.updateDog(id, payload);
  Future<void> deleteDog(String id) => _repository.deleteDog(id);
  Future<Dog> uploadAvatar(
    String dogId, {
    required Uint8List fileBytes,
    required String filename,
    String? mimeType,
  }) =>
      _repository.uploadAvatar(
        dogId,
        fileBytes: fileBytes,
        filename: filename,
        mimeType: mimeType,
      );

  Future<List<BehaviorSnapshot>> listBehaviorSnapshots(String dogId) =>
      _repository.listBehaviorSnapshots(dogId);

  Future<BehaviorSnapshot> createBehaviorSnapshot(
    String dogId,
    Map<String, dynamic> payload,
  ) =>
      _repository.createBehaviorSnapshot(dogId, payload);
}
