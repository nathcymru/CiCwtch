import 'package:flutter/material.dart';

import 'package:cicwtch/features/invoices/application/invoices_service.dart';
import 'package:cicwtch/features/invoices/data/invoices_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';

import 'invoice_form_screen.dart';

class InvoiceCreateScreen extends StatelessWidget {
  const InvoiceCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = InvoicesService(
      InvoicesRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );
    return InvoiceFormScreen(
      onSubmit: (payload) async {
        await service.createInvoice(payload);
      },
    );
  }
}
