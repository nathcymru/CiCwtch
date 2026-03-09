import 'package:flutter/material.dart';

import 'package:cicwtch/features/walkers/application/walkers_service.dart';
import 'package:cicwtch/features/walkers/data/walkers_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';

import 'walker_form_screen.dart';

class WalkerCreateScreen extends StatelessWidget {
  const WalkerCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = WalkersService(
      WalkersRepository(buildApiClient()),
    );

    return WalkerFormScreen(
      onSubmit: (payload) async {
        await service.createWalker(payload);
      },
    );
  }
}
