import 'package:flutter/material.dart';

import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'invoice_form_screen.dart';

class InvoiceEditScreen extends StatelessWidget {
  const InvoiceEditScreen({super.key, required this.invoice});

  final InvoiceHeader invoice;

  @override
  Widget build(BuildContext context) {
    final service = InvoicesService(
      InvoicesRepository(buildApiClient()),
    );
    return InvoiceFormScreen(
      invoice: invoice,
      onSubmit: (payload) async {
        await service.updateInvoice(invoice.id, payload);
      },
    );
  }
}
