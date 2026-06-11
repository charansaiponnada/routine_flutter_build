import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/curriculum.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/curriculum_provider.dart';

class CurriculumRadarChart extends ConsumerWidget {
  const CurriculumRadarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(curriculumNotifierProvider.notifier);
    final courses = Curriculum.courses;
    final values = courses.map((c) => notifier.getProgress(c.id) * 5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COURSE PROGRESS',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.circle,
              tickCount: 5,
              tickBorderData: const BorderSide(color: AppColors.bgElevated),
              gridBorderData: const BorderSide(color: AppColors.bgElevated),
              titlePositionPercentageOffset: 0.2,
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.accentGreen.withAlpha(40),
                  borderColor: AppColors.accentGreen,
                  borderWidth: 2,
                  dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
                ),
              ],
              getTitle: (index, _) {
                final course = courses[index];
                final shortName = course.name.split(':').first;
                return RadarChartTitle(text: shortName);
              },
            ),
            swapAnimationDuration: const Duration(milliseconds: 400),
          ),
        ),
      ],
    );
  }
}
