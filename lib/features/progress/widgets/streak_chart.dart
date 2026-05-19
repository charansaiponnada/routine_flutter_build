import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../providers/streak_provider.dart';

class StreakChart extends ConsumerWidget {
  const StreakChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(streakHistoryProvider);
    final maxStreak = _calculateMaxStreak(history);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STREAK HISTORY (30D)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: history.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
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
                minX: 0,
                maxX: 29,
                minY: 0,
                maxY: maxStreak,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxStreak(List<double> history) {
    double max = 7.0; // Minimum maxY
    for (var s in history) {
      if (s > max) max = s;
    }
    return (max + 2).ceilToDouble();
  }
}
