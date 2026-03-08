import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class WalkersService {
  WalkersService(this._repository);

  final WalkersRepository _repository;

  Future<List<Walker>> listWalkers() => _repository.listWalkers();
  Future<Walker> getWalker(String id) => _repository.getWalker(id);
  Future<Walker> createWalker(Map<String, dynamic> payload) =>
      _repository.createWalker(payload);
  Future<Walker> updateWalker(String id, Map<String, dynamic> payload) =>
      _repository.updateWalker(id, payload);
  Future<void> deleteWalker(String id) => _repository.deleteWalker(id);
}
