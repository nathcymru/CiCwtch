import 'package:flutter/material.dart';

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
            children: const [
              Icon(Icons.pets, size: 72),
              SizedBox(height: 16),
              Text(
                'CiCwtch Flutter starter is ready.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                'A calm, structured foundation for building the app properly.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
