import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class BreedsRepository {
  BreedsRepository(this._api);

  final ApiClient _api;

  Future<List<Breed>> listBreeds() async {
    final json = await _api.get('/api/v1/breeds') as List<dynamic>;
    return json
        .map((e) => Breed.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
