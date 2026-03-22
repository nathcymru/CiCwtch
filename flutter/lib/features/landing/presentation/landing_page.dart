import 'package:flutter/material.dart';

import 'sections/brand_story_section.dart';
import 'sections/feature_grid_section.dart';
import 'sections/final_cta_section.dart';
import 'sections/hero_section.dart';
import 'sections/payments_section.dart';
import 'sections/trust_section.dart';
import 'sections/walk_reports_section.dart';

/// Public-facing landing page shown to unauthenticated users on the root domain.
///
/// The page is composed of reusable section widgets stacked in a single
/// [ListView] for mobile, and adapts internally via [LayoutBuilder] for
/// wider viewports.
class LandingPage extends StatelessWidget {
  /// Called when any CTA button is tapped.  The parent widget is responsible
  /// for navigating the user to the sign-in / sign-up flow.
  final VoidCallback onCtaTapped;

  const LandingPage({super.key, required this.onCtaTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HeroSection(onCtaTapped: onCtaTapped),
          const BrandStorySection(),
          const FeatureGridSection(),
          const WalkReportsSection(),
          const PaymentsSection(),
          const TrustSection(),
          FinalCtaSection(onCtaTapped: onCtaTapped),
          _LandingFooter(onCtaTapped: onCtaTapped),
        ],
      ),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  final VoidCallback onCtaTapped;

  const _LandingFooter({required this.onCtaTapped});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              Text(
                'CiCwtch',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The professional heart of your dog walking business.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onCtaTapped,
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 16),
              Text(
                '© ${DateTime.now().year} CiCwtch. All rights reserved.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
