import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class InvoicesService {
  InvoicesService(this._repository);

  final InvoicesRepository _repository;

  Future<List<InvoiceHeader>> listInvoices() => _repository.listInvoices();
  Future<InvoiceHeader> getInvoice(String id) => _repository.getInvoice(id);
  Future<InvoiceHeader> createInvoice(Map<String, dynamic> payload) =>
      _repository.createInvoice(payload);
  Future<InvoiceHeader> updateInvoice(
          String id, Map<String, dynamic> payload) =>
      _repository.updateInvoice(id, payload);
  Future<void> deleteInvoice(String id) => _repository.deleteInvoice(id);
}
