import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class WalksService {
  WalksService(this._repository);

  final WalksRepository _repository;

  Future<List<Walk>> listWalks() => _repository.listWalks();
  Future<Walk> getWalk(String id) => _repository.getWalk(id);
  Future<Walk> createWalk(Map<String, dynamic> payload) =>
      _repository.createWalk(payload);
  Future<Walk> updateWalk(String id, Map<String, dynamic> payload) =>
      _repository.updateWalk(id, payload);
  Future<void> deleteWalk(String id) => _repository.deleteWalk(id);
}
