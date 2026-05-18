import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class StreakChart extends StatelessWidget {
  const StreakChart({super.key});

  @override
  Widget build(BuildContext context) {
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
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(5, 7),
                      FlSpot(10, 5),
                      FlSpot(15, 12),
                      FlSpot(20, 15),
                      FlSpot(25, 22),
                      FlSpot(30, 28),
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
        ],
      ),
    );
  }
}
