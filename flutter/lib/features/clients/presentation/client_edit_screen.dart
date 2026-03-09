import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/application/clients_service.dart';
import 'package:cicwtch/features/clients/data/clients_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'client_form_screen.dart';

class ClientEditScreen extends StatelessWidget {
  const ClientEditScreen({super.key, required this.client});

  final Client client;

  @override
  Widget build(BuildContext context) {
    final service = ClientsService(
      ClientsRepository(buildApiClient()),
    );

    return ClientFormScreen(
      client: client,
      onSubmit: (payload) async {
        await service.updateClient(client.id, payload);
      },
    );
  }
}
