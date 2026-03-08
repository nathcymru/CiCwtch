import 'package:flutter/material.dart';

class InvoiceStatusBadge extends StatelessWidget {
  const InvoiceStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color backgroundColor;
    final Color labelColor;

    switch (status) {
      case 'draft':
        backgroundColor = colorScheme.surfaceContainerHighest;
        labelColor = colorScheme.onSurfaceVariant;
      case 'issued':
        backgroundColor = colorScheme.primaryContainer;
        labelColor = colorScheme.onPrimaryContainer;
      case 'paid':
        backgroundColor = const Color(0xFFD0F0C0);
        labelColor = const Color(0xFF1B5E20);
      case 'cancelled':
        backgroundColor = colorScheme.errorContainer;
        labelColor = colorScheme.onErrorContainer;
      default:
        backgroundColor = colorScheme.surfaceContainerHighest;
        labelColor = colorScheme.onSurfaceVariant;
    }

    final label = status.isEmpty
        ? '—'
        : '${status[0].toUpperCase()}${status.substring(1)}';

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
