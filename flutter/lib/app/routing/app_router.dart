import 'package:flutter/material.dart';

import 'package:cicwtch/features/clients/presentation/client_create_screen.dart';
import 'package:cicwtch/features/clients/presentation/client_detail_screen.dart';
import 'package:cicwtch/features/clients/presentation/client_edit_screen.dart';
import 'package:cicwtch/features/clients/presentation/clients_list_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_create_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_detail_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dog_edit_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dogs_list_screen.dart';
import 'package:cicwtch/features/walkers/presentation/walker_create_screen.dart';
import 'package:cicwtch/features/walkers/presentation/walker_detail_screen.dart';
import 'package:cicwtch/features/walkers/presentation/walker_edit_screen.dart';
import 'package:cicwtch/features/walkers/presentation/walkers_list_screen.dart';
import 'package:cicwtch/features/walks/presentation/walk_create_screen.dart';
import 'package:cicwtch/features/walks/presentation/walk_detail_screen.dart';
import 'package:cicwtch/features/walks/presentation/walk_edit_screen.dart';
import 'package:cicwtch/features/walks/presentation/walks_list_screen.dart';
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
  static const walksList = '/walks';
  static const walkDetail = '/walks/detail';
  static const walkCreate = '/walks/create';
  static const walkEdit = '/walks/edit';
  static const walkersList = '/walkers';
  static const walkerDetail = '/walkers/detail';
  static const walkerCreate = '/walkers/create';
  static const walkerEdit = '/walkers/edit';
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
      case AppRoutes.walksList:
        return MaterialPageRoute(
          builder: (_) => const WalksListScreen(),
          settings: settings,
        );
      case AppRoutes.walkDetail:
        final walkId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WalkDetailScreen(walkId: walkId),
          settings: settings,
        );
      case AppRoutes.walkCreate:
        return MaterialPageRoute(
          builder: (_) => const WalkCreateScreen(),
          settings: settings,
        );
      case AppRoutes.walkEdit:
        final walk = settings.arguments as Walk;
        return MaterialPageRoute(
          builder: (_) => WalkEditScreen(walk: walk),
          settings: settings,
        );
      case AppRoutes.walkersList:
        return MaterialPageRoute(
          builder: (_) => const WalkersListScreen(),
          settings: settings,
        );
      case AppRoutes.walkerDetail:
        final walkerId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WalkerDetailScreen(walkerId: walkerId),
          settings: settings,
        );
      case AppRoutes.walkerCreate:
        return MaterialPageRoute(
          builder: (_) => const WalkerCreateScreen(),
          settings: settings,
        );
      case AppRoutes.walkerEdit:
        final walker = settings.arguments as Walker;
        return MaterialPageRoute(
          builder: (_) => WalkerEditScreen(walker: walker),
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
