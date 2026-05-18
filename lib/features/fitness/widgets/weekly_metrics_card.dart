import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';

class WeeklyMetricsCard extends StatelessWidget {
  final double? weight;
  final double? waist;
  final VoidCallback onEdit;

  const WeeklyMetricsCard({
    super.key,
    this.weight,
    this.waist,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY METRICS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.accentAmber),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetric(context, 'Weight', '${weight ?? '--'}', 'kg'),
              const SizedBox(width: 32),
              _buildMetric(context, 'Waist', '${waist ?? '--'}', 'cm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTheme.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
