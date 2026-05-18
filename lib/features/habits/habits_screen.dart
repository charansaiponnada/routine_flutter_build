import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/habit_data.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/daily_log_provider.dart';
import '../../models/habit_entry.dart';
import 'widgets/habit_card.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAllCompleted(DailyLogNotifier notifier) {
    final state = ref.read(dailyLogNotifierProvider);
    final completedCount = state.habits.where((h) {
      final def = HabitData.definitions.firstWhere((d) => d.id == h.habitId);
      if (def.type == HabitType.boolean) return h.value == true;
      return (h.value ?? 0) > 0;
    }).length;

    if (completedCount == HabitData.definitions.length) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAILY HABITS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.verticalPadding,
            ),
            itemCount: HabitData.definitions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final definition = HabitData.definitions[index];
              final habitEntry = dailyLog.habits.firstWhere(
                (h) => h.habitId == definition.id,
                orElse: () => HabitEntry(
                  habitId: definition.id,
                  value: definition.type == HabitType.boolean ? false : 0,
                  timestamp: DateTime.now(),
                ),
              );

              return FadeInLeft(
                duration: AppConstants.fastAnim,
                delay: Duration(milliseconds: index * 50),
                child: HabitCard(
                  definition: definition,
                  value: habitEntry.value,
                  onChanged: (newValue) {
                    notifier.updateHabit(definition.id, newValue);
                    _checkAllCompleted(notifier);
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [AppColors.accentGreen, AppColors.accentCyan],
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}
