import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class HabitRadarChart extends StatelessWidget {
  const HabitRadarChart({super.key});

  @override
  Widget build(BuildContext context) {
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
                    dataEntries: const [
                      RadarEntry(value: 5),
                      RadarEntry(value: 4),
                      RadarEntry(value: 3),
                      RadarEntry(value: 5),
                      RadarEntry(value: 4),
                    ],
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
