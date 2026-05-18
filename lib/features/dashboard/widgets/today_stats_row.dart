import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/stat_chip.dart';

class TodayStatsRow extends StatelessWidget {
  const TodayStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatChip(
          label: 'Study',
          value: '4.5h',
          color: AppColors.accentCyan,
        ),
        StatChip(
          label: 'Probs',
          value: '12',
          color: AppColors.accentGreen,
        ),
        StatChip(
          label: 'Gym',
          value: '45m',
          color: AppColors.accentAmber,
        ),
        StatChip(
          label: 'Streak',
          value: '12d',
          color: AppColors.accentRed,
        ),
      ],
    );
  }
}
