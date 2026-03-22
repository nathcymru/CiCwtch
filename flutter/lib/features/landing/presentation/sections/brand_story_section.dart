import 'package:flutter/material.dart';

/// Brand story section — explains who CiCwtch is for.
class BrandStorySection extends StatelessWidget {
  const BrandStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Brand story section',
      child: Container(
        width: double.infinity,
        color: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Built by walkers, for walkers',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Running a dog walking business means juggling clients, dogs, '
                  'bookings, invoices, and walker compliance — often on your own. '
                  'CiCwtch was designed to take the administrative weight off your '
                  'shoulders so you can focus on the part you love: being with dogs.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '"Ci Cwtch" — a Welsh phrase meaning a little hug — captures '
                  'everything we believe a great dog walking service should feel like: '
                  'warm, trustworthy, and close to home.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontStyle: FontStyle.italic,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
