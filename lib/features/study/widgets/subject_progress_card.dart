import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';

class SubjectProgressCard extends StatelessWidget {
  final String name;
  final String weightage;
  final double progress;
  final VoidCallback onTap;

  const SubjectProgressCard({
    super.key,
    required this.name,
    required this.weightage,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getWeightageColor().withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  weightage.toUpperCase(),
                  style: AppTheme.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getWeightageColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.bgSurface,
            color: AppColors.accentCyan,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'COVERAGE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTheme.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getWeightageColor() {
    if (weightage == 'high') return AppColors.accentRed;
    if (weightage == 'medium') return AppColors.accentAmber;
    return AppColors.accentGreen;
  }
}
