import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_factory.dart';

import 'dog_form_screen.dart';

class DogCreateScreen extends StatelessWidget {
  const DogCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = DogsService(
      DogsRepository(buildApiClient()),
    );
    return DogFormScreen(
      onSubmit: (payload) async {
        await service.createDog(payload);
      },
    );
  }
}
