import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';

void main() {
  runApp(const CiCwtchApp());
}

class CiCwtchApp extends StatelessWidget {
  const CiCwtchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CiCwtch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F7A28)),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CiCwtch'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pets, size: 72),
              const SizedBox(height: 16),
              const Text(
                'CiCwtch Flutter starter is ready.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'A calm, structured foundation for building the app properly.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Clients'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.clientsList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
