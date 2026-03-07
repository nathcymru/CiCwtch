import 'package:flutter/material.dart';

import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walker_form_screen.dart';

class WalkerEditScreen extends StatelessWidget {
  const WalkerEditScreen({super.key, required this.walker});

  final Walker walker;

  @override
  Widget build(BuildContext context) {
    final service = WalkersService(
      WalkersRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );

    return WalkerFormScreen(
      walker: walker,
      onSubmit: (payload) async {
        await service.updateWalker(walker.id, payload);
      },
    );
  }
}
