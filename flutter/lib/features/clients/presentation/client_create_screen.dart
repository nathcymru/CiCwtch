import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';

import 'client_form_screen.dart';

class ClientCreateScreen extends StatelessWidget {
  const ClientCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ClientsService(
      ClientsRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );

    return ClientFormScreen(
      onSubmit: (payload) async {
        await service.createClient(payload);
      },
    );
  }
}
