import 'package:flutter/material.dart';

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const List<_FeatureItem> _features = [
  _FeatureItem(
    icon: Icons.people_outline,
    title: 'Client management',
    description:
        "Keep every client's details, dogs, and preferences in one organised place.",
  ),
  _FeatureItem(
    icon: Icons.pets,
    title: 'Dog profiles',
    description:
        'Full dog records including breed, health notes, behaviour ratings, and walking gear.',
  ),
  _FeatureItem(
    icon: Icons.route_outlined,
    title: 'Walk scheduling',
    description:
        'Create and manage walks with start times, assigned walkers, and GPS-ready notes.',
  ),
  _FeatureItem(
    icon: Icons.assignment_outlined,
    title: 'Walk reports',
    description:
        'Detailed post-walk reports sent straight to clients, building trust on every visit.',
  ),
  _FeatureItem(
    icon: Icons.group_outlined,
    title: 'Walker management',
    description:
        'Onboard walkers, track compliance records, and assign walks with ease.',
  ),
  _FeatureItem(
    icon: Icons.receipt_long_outlined,
    title: 'Invoicing',
    description:
        'Generate professional invoices directly from completed walks and send them instantly.',
  ),
];

/// Feature grid section — shows the six core feature areas.
class FeatureGridSection extends StatelessWidget {
  const FeatureGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Features section',
      child: Container(
        width: double.infinity,
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Everything you need',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Purpose-built tools for professional dog walking operations.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth >= 600 ? 3 : 1;
                    return _FeatureGrid(
                      features: _features,
                      crossAxisCount: crossAxisCount,
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

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> features;
  final int crossAxisCount;

  const _FeatureGrid({
    required this.features,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return Column(
        children: features
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _FeatureCard(item: f),
                ))
            .toList(),
      );
    }

    // Build rows of crossAxisCount cards.
    final rows = <Widget>[];
    for (var i = 0; i < features.length; i += crossAxisCount) {
      final rowItems = features.skip(i).take(crossAxisCount).toList();
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = 0; j < rowItems.length; j++) ...[
                if (j > 0) const SizedBox(width: 24),
                Expanded(child: _FeatureCard(item: rowItems[j])),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, size: 36, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
