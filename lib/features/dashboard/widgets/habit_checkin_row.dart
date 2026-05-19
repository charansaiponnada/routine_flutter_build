import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/constants/habit_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/daily_log_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../models/habit_entry.dart';

class HabitCheckinRow extends ConsumerWidget {
  const HabitCheckinRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);

    // Only show boolean habits for quick check-in
    final quickHabits = HabitData.definitions
        .where((d) => d.type == HabitType.boolean)
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'QUICK CHECK-IN',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: quickHabits.map((habit) {
              final entry = dailyLog.habits.firstWhere(
                (h) => h.habitId == habit.id,
                orElse: () => HabitEntry(
                  habitId: habit.id,
                  value: false,
                  timestamp: DateTime.now(),
                ),
              );
              final isDone = entry.value == true;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => notifier.updateHabit(habit.id, !isDone),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: isDone ? AppColors.accentGreen.withOpacity(0.1) : AppColors.bgCard,
                    borderColor: isDone ? AppColors.accentGreen.withOpacity(0.3) : AppColors.borderColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          habit.icon,
                          color: isDone ? AppColors.accentGreen : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          habit.name.split(' ').first, // Just the first word for brevity
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: isDone ? AppColors.accentGreen : AppColors.textSecondary,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
