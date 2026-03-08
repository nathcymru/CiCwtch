import 'package:flutter/material.dart';

import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';

import 'walk_form_screen.dart';

class WalkCreateScreen extends StatelessWidget {
  const WalkCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = WalksService(
      WalksRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );
    return WalkFormScreen(
      onSubmit: (payload) async {
        await service.createWalk(payload);
      },
    );
  }
}
