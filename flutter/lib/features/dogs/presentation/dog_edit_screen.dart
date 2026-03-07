import 'package:flutter/material.dart';

import 'package:cicwtch/features/dogs/application/dogs_service.dart';
import 'package:cicwtch/features/dogs/data/dogs_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

import 'dog_form_screen.dart';

class DogEditScreen extends StatelessWidget {
  const DogEditScreen({super.key, required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    final service = DogsService(
      DogsRepository(ApiClient(baseUrl: ApiConfig.baseUrl)),
    );
    return DogFormScreen(
      dog: dog,
      onSubmit: (payload) async {
        await service.updateDog(dog.id, payload);
      },
    );
  }
}
