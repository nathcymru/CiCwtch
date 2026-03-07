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
}
