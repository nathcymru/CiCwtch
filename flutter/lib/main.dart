import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/features/dashboard/presentation/dashboard_screen.dart';

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
      home: const DashboardScreen(),
    );
  }
}
