import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/presentation/client_create_screen.dart';
import 'package:cicwtch/features/clients/presentation/client_detail_screen.dart';
import 'package:cicwtch/features/clients/presentation/client_edit_screen.dart';
import 'package:cicwtch/features/clients/presentation/clients_list_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_create_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_detail_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_edit_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dogs_list_screen.dart';
import 'package:cicwtch/shared/domain/models/models.dart';

class AppRoutes {
  static const home = '/';
  static const clientsList = '/clients';
  static const clientDetail = '/clients/detail';
  static const clientCreate = '/clients/create';
  static const clientEdit = '/clients/edit';
  static const dogsList = '/dogs';
  static const dogDetail = '/dogs/detail';
  static const dogCreate = '/dogs/create';
  static const dogEdit = '/dogs/edit';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.clientsList:
        return MaterialPageRoute(
          builder: (_) => const ClientsListScreen(),
          settings: settings,
        );
      case AppRoutes.clientDetail:
        final clientId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ClientDetailScreen(clientId: clientId),
          settings: settings,
        );
      case AppRoutes.clientCreate:
        return MaterialPageRoute(
          builder: (_) => const ClientCreateScreen(),
          settings: settings,
        );
      case AppRoutes.clientEdit:
        final client = settings.arguments as Client;
        return MaterialPageRoute(
          builder: (_) => ClientEditScreen(client: client),
          settings: settings,
        );
      case AppRoutes.dogsList:
        return MaterialPageRoute(
          builder: (_) => const DogsListScreen(),
          settings: settings,
        );
      case AppRoutes.dogDetail:
        final dogId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DogDetailScreen(dogId: dogId),
          settings: settings,
        );
      case AppRoutes.dogCreate:
        return MaterialPageRoute(
          builder: (_) => const DogCreateScreen(),
          settings: settings,
        );
      case AppRoutes.dogEdit:
        final dog = settings.arguments as Dog;
        return MaterialPageRoute(
          builder: (_) => DogEditScreen(dog: dog),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: const Center(child: Text('Page not found.')),
    );
  }
}
