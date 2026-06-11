import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';

class ProgressRingCard extends StatelessWidget {
  final double percent;

  const ProgressRingCard({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: percent,
            animation: true,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: AppColors.bgSurface,
            progressColor: AppColors.accentGreen,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(percent * 100).toInt()}%',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'COMPLETE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Keep forging. You are winning.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
