import 'package:flutter/material.dart';

import 'package:cicwtch/features/walks/application/walks_service.dart';
import 'package:cicwtch/features/walks/data/walks_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'walk_form_screen.dart';

class WalkEditScreen extends StatelessWidget {
  const WalkEditScreen({super.key, required this.walk});

  final Walk walk;

  @override
  Widget build(BuildContext context) {
    final service = WalksService(
      WalksRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );
    return WalkFormScreen(
      walk: walk,
      onSubmit: (payload) async {
        await service.updateWalk(walk.id, payload);
      },
    );
  }
}
