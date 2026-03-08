import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class InvoicesRepository {
  InvoicesRepository(this._api);

  final ApiClient _api;

  Future<List<InvoiceHeader>> listInvoices() async {
    final json = await _api.get('/api/v1/invoice-headers') as List<dynamic>;
    return json
        .map((e) => InvoiceHeader.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InvoiceHeader> getInvoice(String id) async {
    final json =
        await _api.get('/api/v1/invoice-headers/$id') as Map<String, dynamic>;
    return InvoiceHeader.fromJson(json);
  }

  Future<InvoiceHeader> createInvoice(Map<String, dynamic> payload) async {
    final json = await _api.post('/api/v1/invoice-headers', payload)
        as Map<String, dynamic>;
    return InvoiceHeader.fromJson(json);
  }

  Future<InvoiceHeader> updateInvoice(
      String id, Map<String, dynamic> payload) async {
    final json = await _api.put('/api/v1/invoice-headers/$id', payload)
        as Map<String, dynamic>;
    return InvoiceHeader.fromJson(json);
  }

  Future<void> deleteInvoice(String id) async {
    await _api.delete('/api/v1/invoice-headers/$id');
  }
}
