import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/daily_log_provider.dart';
import '../../../providers/streak_provider.dart';
import '../../../shared/widgets/stat_chip.dart';

class TodayStatsRow extends ConsumerWidget {
  const TodayStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogNotifierProvider);
    final streak = ref.watch(currentStreakProvider);

    // Calculate Study Hours
    final studyMinutes = log.studySessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final studyHours = (studyMinutes / 60).toStringAsFixed(1);

    // Calculate LeetCode Problems
    final leetcodeHabit = log.habits.cast<dynamic>().firstWhere(
      (h) => h.habitId == 'leetcode',
      orElse: () => null,
    );
    final leetcodeCount = leetcodeHabit?.value?.toString() ?? '0';

    // Workout status
    final workoutStatus = log.workout?.isCompleted == true ? 'Done' : 'No';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatChip(
          label: 'Study',
          value: '${studyHours}h',
          color: AppColors.accentCyan,
        ),
        StatChip(
          label: 'Probs',
          value: leetcodeCount,
          color: AppColors.accentGreen,
        ),
        StatChip(
          label: 'Gym',
          value: workoutStatus,
          color: AppColors.accentAmber,
        ),
        StatChip(
          label: 'Streak',
          value: '${streak}d',
          color: AppColors.accentRed,
        ),
      ],
    );
  }
}
