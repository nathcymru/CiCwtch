import 'package:flutter/material.dart';

import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/app/shell/app_shell.dart';
import 'package:cicwtch/theme/app_theme.dart';

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      home: const AppShell(),
    );
  }
}
