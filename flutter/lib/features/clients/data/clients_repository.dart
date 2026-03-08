import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class ClientsRepository {
  ClientsRepository(this._api);

  final ApiClient _api;

  Future<List<Client>> listClients() async {
    final json = await _api.get('/api/v1/clients') as List<dynamic>;
    return json.map((e) => Client.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Client> getClient(String id) async {
    final json = await _api.get('/api/v1/clients/$id') as Map<String, dynamic>;
    return Client.fromJson(json);
  }

  Future<Client> createClient(Map<String, dynamic> payload) async {
    final json = await _api.post('/api/v1/clients', payload) as Map<String, dynamic>;
    return Client.fromJson(json);
  }

  Future<Client> updateClient(String id, Map<String, dynamic> payload) async {
    final json = await _api.put('/api/v1/clients/$id', payload) as Map<String, dynamic>;
    return Client.fromJson(json);
  }

  Future<void> deleteClient(String id) async {
    await _api.delete('/api/v1/clients/$id');
  }
}
