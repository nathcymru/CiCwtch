import 'package:flutter/material.dart';

/// Hero section — first thing visitors see on the landing page.
class HeroSection extends StatelessWidget {
  final VoidCallback onCtaTapped;

  const HeroSection({super.key, required this.onCtaTapped});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Hero section',
      child: Container(
        width: double.infinity,
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'The Professional Heart of Your Dog Walking Business',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CiCwtch gives independent dog walkers and small agencies the tools to '
                  'manage clients, walks, walkers, and invoices — all in one place.',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                FilledButton.icon(
                  onPressed: onCtaTapped,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Get started'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
