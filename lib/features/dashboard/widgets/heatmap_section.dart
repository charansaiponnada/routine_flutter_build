import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class HeatmapSection extends StatelessWidget {
  const HeatmapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DISCIPLINE HEATMAP',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: List.generate(10, (weekIndex) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    children: List.generate(7, (dayIndex) {
                      // Mock intensity for now
                      final intensity = Random().nextInt(5);
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: _getColorForIntensity(intensity),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForIntensity(int intensity) {
    if (intensity == 0) return AppColors.bgSurface;
    return AppColors.accentGreen.withOpacity(0.2 * intensity);
  }
}
