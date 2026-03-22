import 'package:flutter/material.dart';

class _TrustPoint {
  final IconData icon;
  final String title;
  final String description;

  const _TrustPoint({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const List<_TrustPoint> _trustPoints = [
  _TrustPoint(
    icon: Icons.lock_outline,
    title: 'Your data, your business',
    description:
        'Each CiCwtch account is isolated to your own tenant. '
        'Your clients and dog records are never shared with anyone else.',
  ),
  _TrustPoint(
    icon: Icons.cloud_outlined,
    title: 'Built on Cloudflare',
    description:
        "Hosted on Cloudflare's global network \u2014 fast, reliable, "
        'and always available wherever your walks take you.',
  ),
  _TrustPoint(
    icon: Icons.devices_outlined,
    title: 'Works on every device',
    description:
        "Whether you're at your desk or on the go, CiCwtch runs on web, "
        'iOS, and Android \u2014 always in sync.',
  ),
];

/// Trust section — reassures visitors about data safety and reliability.
class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Trust and security section',
      child: Container(
        width: double.infinity,
        color: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Built to be trusted',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _trustPoints
                            .map((p) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: _TrustCard(
                                        point: p,
                                        colorScheme: colorScheme,
                                        textTheme: textTheme),
                                  ),
                                ))
                            .toList(),
                      );
                    }
                    return Column(
                      children: _trustPoints
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _TrustCard(
                                    point: p,
                                    colorScheme: colorScheme,
                                    textTheme: textTheme),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  final _TrustPoint point;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TrustCard({
    required this.point,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(point.icon, size: 40, color: colorScheme.onSecondaryContainer),
        const SizedBox(height: 12),
        Text(
          point.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          point.description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSecondaryContainer,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
