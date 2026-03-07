import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class ClientsService {
  ClientsService(this._repository);

  final ClientsRepository _repository;

  Future<List<Client>> listClients() => _repository.listClients();

  Future<Client> getClient(String id) => _repository.getClient(id);

  Future<Client> createClient(Map<String, dynamic> payload) =>
      _repository.createClient(payload);

  Future<Client> updateClient(String id, Map<String, dynamic> payload) =>
      _repository.updateClient(id, payload);

  Future<void> deleteClient(String id) => _repository.deleteClient(id);
}
