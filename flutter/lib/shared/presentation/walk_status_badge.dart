import 'package:flutter/material.dart';

class WalkStatusBadge extends StatelessWidget {
  const WalkStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color backgroundColor;
    final Color labelColor;
    final String label;

    switch (status) {
      case 'planned':
        backgroundColor = colorScheme.surfaceContainerHighest;
        labelColor = colorScheme.onSurfaceVariant;
        label = 'Planned';
      case 'in_progress':
        backgroundColor = const Color(0xFFFFE082);
        labelColor = const Color(0xFF6D4C00);
        label = 'In progress';
      case 'completed':
        backgroundColor = const Color(0xFFD0F0C0);
        labelColor = const Color(0xFF1B5E20);
        label = 'Completed';
      case 'cancelled':
        backgroundColor = colorScheme.errorContainer;
        labelColor = colorScheme.onErrorContainer;
        label = 'Cancelled';
      default:
        backgroundColor = colorScheme.surfaceContainerHighest;
        labelColor = colorScheme.onSurfaceVariant;
        label = status.isEmpty ? '—' : status;
    }

    return Chip(
      label: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: labelColor),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
