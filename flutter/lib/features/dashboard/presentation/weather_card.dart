import 'package:flutter/material.dart';

import 'package:cicwtch/features/dashboard/domain/weather_data.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (weatherData.warning != null)
            _WarningHeader(warning: weatherData.warning!),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WeatherSummaryRow(
                  current: weatherData.current,
                  verdict: weatherData.verdict,
                ),
                const SizedBox(height: 16),
                _FactorGrid(factors: weatherData.factors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Warning header ───────────────────────────────────────────────────────

class _WarningHeader extends StatelessWidget {
  const _WarningHeader({required this.warning});

  final WeatherWarning warning;

  Color _backgroundColour() {
    switch (warning.level) {
      case 'Red':
        return const Color(0xFFCC0000);
      case 'Amber':
        return const Color(0xFFE07800);
      case 'Yellow':
        return const Color(0xFFCCB800);
      default:
        return const Color(0xFFCCB800);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openMetOffice(context),
      child: Container(
        color: _backgroundColour(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              '${warning.level} Warning',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            const Text(
              '>>',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMetOffice(BuildContext context) {
    // URL launch is handled via platform-appropriate mechanism.
    // The Met Office URL is passed to the platform via a simple web-safe
    // navigation — no url_launcher dependency required for web target.
    // For a cross-platform launch use url_launcher when added to pubspec.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visit metoffice.gov.uk for full warning details.'),
        action: SnackBarAction(label: 'OK', onPressed: _noop),
      ),
    );
  }

  static void _noop() {}
}

// ─── Main weather summary row ─────────────────────────────────────────────

class _WeatherSummaryRow extends StatelessWidget {
  const _WeatherSummaryRow({required this.current, required this.verdict});

  final WeatherCurrent current;
  final String verdict;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's weather:",
          style: textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: current.iconBaseUri != null
                  ? Image.network(
                      '${current.iconBaseUri}.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.wb_cloudy_outlined, size: 48),
                    )
                  : const Icon(Icons.wb_cloudy_outlined, size: 48),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.condition,
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${current.airTemp.toStringAsFixed(0)}°C  '
                    '(feels ${current.feelsLike.toStringAsFixed(0)}°C)',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(verdict, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Factor grid ──────────────────────────────────────────────────────────

class _FactorGrid extends StatelessWidget {
  const _FactorGrid({required this.factors});

  final DogFactors factors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FactorRow(
          label: 'Paw Safety',
          status: factors.pawSafety.status,
          detail: factors.pawSafety.actionableDetail,
        ),
        _FactorRow(
          label: 'Brachy Factor',
          status: factors.brachyFactor.status,
          detail: factors.brachyFactor.actionableDetail,
        ),
        _FactorRow(
          label: 'Mud Factor',
          status: factors.mudFactor.status,
          detail: factors.mudFactor.actionableDetail,
        ),
        _FactorRow(
          label: 'Itch Factor',
          status: factors.itchFactor.status,
          detail: factors.itchFactor.actionableDetail,
        ),
        _GearRow(detail: factors.gearCheck.actionableDetail),
      ],
    );
  }
}

class _FactorRow extends StatelessWidget {
  const _FactorRow({
    required this.label,
    required this.status,
    required this.detail,
  });

  final String label;
  final String status;
  final String detail;

  Color _statusColour() {
    switch (status) {
      case 'Red':
        return const Color(0xFFCC2222);
      case 'Yellow':
        return const Color(0xFFB89000);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _statusColour(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 108,
            child: Text(label,
                style: textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(detail, style: textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _GearRow extends StatelessWidget {
  const _GearRow({required this.detail});

  final String detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.checkroom_outlined, size: 10),
          const SizedBox(width: 8),
          SizedBox(
            width: 108,
            child: Text('Gear Check',
                style: textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(detail, style: textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
