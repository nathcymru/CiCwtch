import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class VetPracticesRepository {
  VetPracticesRepository(this._api);

  final ApiClient _api;

  Future<List<VeterinaryPractice>> listVetPractices() async {
    final json = await _api.get('/api/v1/vet-practices') as List<dynamic>;
    return json
        .map((e) => VeterinaryPractice.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
