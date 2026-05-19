import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../providers/study_provider.dart';

class StudyHoursChart extends ConsumerWidget {
  const StudyHoursChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studySessions = ref.watch(studyNotifierProvider);
    final weeklyData = _calculateWeeklyData(studySessions);
    final maxHours = _calculateMaxHours(weeklyData);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY STUDY HOURS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxHours,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.bgElevated,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)} hrs',
                        const TextStyle(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[value.toInt() % 7],
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.asMap().entries.map((entry) {
                  return _makeGroupData(entry.key, entry.value, maxHours);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _calculateWeeklyData(dynamic sessions) {
    final now = DateTime.now();
    // Start from Monday of this week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => DateTime(monday.year, monday.month, monday.day).add(Duration(days: i)));
    
    final dailyHours = List.generate(7, (i) => 0.0);
    
    for (final session in sessions) {
      final sessionDate = DateTime(session.date.year, session.date.month, session.date.day);
      for (int i = 0; i < 7; i++) {
        if (sessionDate.isAtSameMomentAs(weekDays[i])) {
          dailyHours[i] += session.durationMinutes / 60.0;
        }
      }
    }
    
    return dailyHours;
  }

  double _calculateMaxHours(List<double> data) {
    double max = 4.0; // Minimum maxY
    for (var h in data) {
      if (h > max) max = h;
    }
    return (max + 1).ceilToDouble();
  }

  BarChartGroupData _makeGroupData(int x, double y, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accentCyan,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: AppColors.bgSurface,
          ),
        ),
      ],
    );
  }
}
