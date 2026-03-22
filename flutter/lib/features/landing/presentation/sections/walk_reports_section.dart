import 'package:flutter/material.dart';

/// Walk reports section — highlights the post-walk reporting feature.
class WalkReportsSection extends StatelessWidget {
  const WalkReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Walk reports section',
      child: Container(
        width: double.infinity,
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              final content = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: isWide
                    ? _WideLayout(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      )
                    : _NarrowLayout(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
              );
              return content;
            },
          ),
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WideLayout({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: _TextContent(colorScheme: colorScheme, textTheme: textTheme),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 4,
          child: _ReportCard(colorScheme: colorScheme, textTheme: textTheme),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _NarrowLayout({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextContent(colorScheme: colorScheme, textTheme: textTheme),
        const SizedBox(height: 32),
        _ReportCard(colorScheme: colorScheme, textTheme: textTheme),
      ],
    );
  }
}

class _TextContent extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TextContent({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Walk reports clients love',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'After every walk, log a detailed report — what happened, how the dog '
          'behaved, any health notes — and share it with the client automatically.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'It builds trust, keeps clients informed, and protects you when something '
          'unexpected happens.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ReportCard({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: colorScheme.tertiary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Walk complete',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Buddy had a great 60-minute group walk this morning. '
              'He played well with the other dogs and showed excellent recall. '
              'Weather was clear — all dogs were towelled off before drop-off.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  'Cardiff Bay Loop',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const Spacer(),
                Text(
                  '08:30 – 09:30',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
