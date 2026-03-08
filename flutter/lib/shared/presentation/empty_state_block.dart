import 'package:flutter/material.dart';

class EmptyStateBlock extends StatelessWidget {
  const EmptyStateBlock({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
