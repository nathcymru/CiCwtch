import 'dart:typed_data';

import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class DogsRepository {
  DogsRepository(this._api);

  final ApiClient _api;

  Future<List<Dog>> listDogs() async {
    final json = await _api.get('/api/v1/dogs') as List<dynamic>;
    return json
        .map((e) => Dog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Dog> getDog(String id) async {
    final json = await _api.get('/api/v1/dogs/$id') as Map<String, dynamic>;
    return Dog.fromJson(json);
  }

  Future<Dog> createDog(Map<String, dynamic> payload) async {
    final json =
        await _api.post('/api/v1/dogs', payload) as Map<String, dynamic>;
    return Dog.fromJson(json);
  }

  Future<Dog> updateDog(String id, Map<String, dynamic> payload) async {
    final json =
        await _api.put('/api/v1/dogs/$id', payload) as Map<String, dynamic>;
    return Dog.fromJson(json);
  }

  Future<void> deleteDog(String id) async {
    await _api.delete('/api/v1/dogs/$id');
  }

  Future<Dog> uploadAvatar(
    String dogId, {
    required Uint8List fileBytes,
    required String filename,
    String? mimeType,
  }) async {
    final json = await _api.postMultipart(
      '/api/v1/dogs/$dogId/avatar',
      fileField: 'avatar_file',
      fileBytes: fileBytes,
      filename: filename,
      mimeType: mimeType,
    ) as Map<String, dynamic>;
    return Dog.fromJson(json);
  }

  Future<List<BehaviorSnapshot>> listBehaviorSnapshots(String dogId) async {
    final json = await _api.get('/api/v1/dogs/$dogId/behavior-snapshots')
        as List<dynamic>;
    return json
        .map((e) => BehaviorSnapshot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BehaviorSnapshot> createBehaviorSnapshot(
    String dogId,
    Map<String, dynamic> payload,
  ) async {
    final json =
        await _api.post('/api/v1/dogs/$dogId/behavior-snapshots', payload)
            as Map<String, dynamic>;
    return BehaviorSnapshot.fromJson(json);
  }
}
