import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/daily_log_provider.dart';
import '../../models/workout_entry.dart';
import 'widgets/weekly_metrics_card.dart';
import '../../shared/widgets/app_card.dart';

class FitnessScreen extends ConsumerWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);
    final workout = dailyLog.workout ?? WorkoutEntry(
      type: 'Home Workout',
      durationMinutes: 45,
      exercises: ['Pushups', 'Squats', 'Plank', 'Burpees'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FITNESS LOG',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: AppConstants.fastAnim,
              child: _buildTodayWorkoutCard(context, workout, notifier),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: AppConstants.mediumAnim,
              child: WeeklyMetricsCard(
                weight: workout.weight,
                waist: workout.waist,
                onEdit: () => _showMetricsDialog(context, workout, notifier),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'WEIGHT TREND (8 WEEKS)',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: AppConstants.slowAnim,
              child: _buildWeightChart(),
            ),
            const SizedBox(height: 32),
            Text(
              'TODAY\'S CIRCUIT',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            ...workout.exercises.asMap().entries.map((entry) => FadeInLeft(
              duration: AppConstants.fastAnim,
              delay: Duration(milliseconds: entry.key * 100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.bgSurface,
                  showShadow: false,
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: AppColors.accentGreen),
                      const SizedBox(width: 12),
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayWorkoutCard(BuildContext context, WorkoutEntry workout, DailyLogNotifier notifier) {
    return AppCard(
      color: workout.isCompleted ? AppColors.accentGreen.withAlpha(20) : AppColors.bgCard,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: workout.isCompleted ? AppColors.accentGreen.withAlpha(40) : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: workout.isCompleted ? AppColors.accentGreen : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Workout',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                Text(
                  workout.isCompleted ? 'Completed today' : 'Not started yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: workout.isCompleted ? AppColors.accentGreen : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: workout.isCompleted,
            activeColor: AppColors.accentGreen,
            onChanged: (val) {
              final newWorkout = WorkoutEntry(
                isCompleted: val,
                type: workout.type,
                durationMinutes: workout.durationMinutes,
                exercises: workout.exercises,
                weight: workout.weight,
                waist: workout.waist,
              );
              notifier.updateWorkout(newWorkout);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart() {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(8, 24, 24, 8),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: AppColors.borderColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 82),
                  const FlSpot(1, 81.5),
                  const FlSpot(2, 81.2),
                  const FlSpot(3, 80.8),
                  const FlSpot(4, 80.5),
                  const FlSpot(5, 80.1),
                  const FlSpot(6, 79.8),
                  const FlSpot(7, 79.5),
                ],
                isCurved: true,
                color: AppColors.accentGreen,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.accentGreen.withAlpha(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMetricsDialog(BuildContext context, WorkoutEntry workout, DailyLogNotifier notifier) {
    final weightController = TextEditingController(text: workout.weight?.toString() ?? '');
    final waistController = TextEditingController(text: workout.waist?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: const Text('Update Metrics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g. 75.5',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: waistController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Waist (cm)',
                hintText: 'e.g. 88.0',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentAmber),
            onPressed: () {
              final newWeight = double.tryParse(weightController.text);
              final newWaist = double.tryParse(waistController.text);
              
              final newWorkout = WorkoutEntry(
                isCompleted: workout.isCompleted,
                type: workout.type,
                durationMinutes: workout.durationMinutes,
                exercises: workout.exercises,
                weight: newWeight,
                waist: newWaist,
              );
              
              notifier.updateWorkout(newWorkout);
              Navigator.pop(context);
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
