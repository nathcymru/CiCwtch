import 'package:flutter/material.dart';

/// Final CTA section — bottom-of-page call to action.
class FinalCtaSection extends StatelessWidget {
  final VoidCallback onCtaTapped;

  const FinalCtaSection({super.key, required this.onCtaTapped});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Call to action section',
      child: Container(
        width: double.infinity,
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Ready to run your business with confidence?',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join CiCwtch and give your dog walking business the professional '
                  'platform it deserves.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                FilledButton.tonal(
                  onPressed: onCtaTapped,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.onPrimary,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Get started today'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
