import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../providers/streak_provider.dart';

class HabitRadarChart extends ConsumerWidget {
  const HabitRadarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(habitRadarStatsProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HABIT CONSISTENCY',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.circle,
                dataSets: [
                  RadarDataSet(
                    fillColor: AppColors.accentGreen.withAlpha(40),
                    borderColor: AppColors.accentGreen,
                    entryRadius: 3,
                    dataEntries: stats.map((v) => RadarEntry(value: v)).toList(),
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: AppColors.borderColor),
                gridBorderData: const BorderSide(color: AppColors.borderColor, width: 1),
                tickBorderData: const BorderSide(color: AppColors.borderColor, width: 1),
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                getTitle: (index, angle) {
                  const labels = ['Study', 'Fitness', 'Wakeup', 'Coding', 'Journal'];
                  return RadarChartTitle(
                    text: labels[index % labels.length],
                    angle: angle,
                  );
                },
                titleTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
