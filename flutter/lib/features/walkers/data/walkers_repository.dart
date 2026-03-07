import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class WalkersRepository {
  WalkersRepository(this._api);

  final ApiClient _api;

  Future<List<Walker>> listWalkers() async {
    final json = await _api.get('/api/v1/walkers') as List<dynamic>;
    return json
        .map((e) => Walker.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Walker> getWalker(String id) async {
    final json = await _api.get('/api/v1/walkers/$id') as Map<String, dynamic>;
    return Walker.fromJson(json);
  }

  Future<Walker> createWalker(Map<String, dynamic> payload) async {
    final json =
        await _api.post('/api/v1/walkers', payload) as Map<String, dynamic>;
    return Walker.fromJson(json);
  }

  Future<Walker> updateWalker(String id, Map<String, dynamic> payload) async {
    final json =
        await _api.put('/api/v1/walkers/$id', payload) as Map<String, dynamic>;
    return Walker.fromJson(json);
  }

  Future<void> deleteWalker(String id) async {
    await _api.delete('/api/v1/walkers/$id');
  }
}
