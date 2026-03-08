import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class WalksRepository {
  WalksRepository(this._api);

  final ApiClient _api;

  Future<List<Walk>> listWalks() async {
    final json = await _api.get('/api/v1/walks') as List<dynamic>;
    return json
        .map((e) => Walk.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Walk> getWalk(String id) async {
    final json = await _api.get('/api/v1/walks/$id') as Map<String, dynamic>;
    return Walk.fromJson(json);
  }

  Future<Walk> createWalk(Map<String, dynamic> payload) async {
    final json =
        await _api.post('/api/v1/walks', payload) as Map<String, dynamic>;
    return Walk.fromJson(json);
  }

  Future<Walk> updateWalk(String id, Map<String, dynamic> payload) async {
    final json =
        await _api.put('/api/v1/walks/$id', payload) as Map<String, dynamic>;
    return Walk.fromJson(json);
  }

  Future<void> deleteWalk(String id) async {
    await _api.delete('/api/v1/walks/$id');
  }
}
