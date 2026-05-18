import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/mock_test.dart';
import '../../../shared/widgets/app_card.dart';
import 'package:intl/intl.dart';

class MockTestTile extends StatelessWidget {
  final MockTest test;

  const MockTestTile({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.bgSurface,
      showShadow: false,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  test.score.toInt().toString(),
                  style: AppTheme.jetBrainsMono(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
                Text(
                  '/${test.totalMarks.toInt()}',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.subject,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(test.date),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          if (test.percentileEstimate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${test.percentileEstimate}%',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
                Text(
                  'PERCENTILE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 8),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
