import 'package:flutter/material.dart';

import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class DogAvatarWidget extends StatelessWidget {
  const DogAvatarWidget({
    super.key,
    required this.dog,
    this.radius = 24,
  });

  final Dog dog;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (dog.avatarObjectKey == null) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.pets, size: radius),
      );
    }

    final token = ApiConfig.bearerToken.trim();
    final url =
        '${ApiConfig.baseUrl}/api/v1/dogs/${dog.id}/avatar';

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(
        url,
        headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : {},
      ),
      onBackgroundImageError: (_, __) {},
    );
  }
}
