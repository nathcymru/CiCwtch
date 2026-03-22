import 'package:flutter/material.dart';

/// Payments section — teases the upcoming Stripe billing integration.
class PaymentsSection extends StatelessWidget {
  const PaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Payments section',
      child: Container(
        width: double.infinity,
        color: colorScheme.tertiaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 48,
                  color: colorScheme.onTertiaryContainer,
                ),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  child: Text(
                    'Payments — coming soon',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'CiCwtch will integrate directly with Stripe so you can collect '
                  'payments, manage subscriptions, and reconcile invoices without '
                  'ever leaving the platform.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'No chasing payments. No manual reconciliation. Just professional, '
                  'automated billing built for small teams.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onTertiaryContainer,
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
