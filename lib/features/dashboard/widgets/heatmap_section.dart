import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/streak_provider.dart';
import '../../../shared/widgets/app_card.dart';

class HeatmapSection extends ConsumerWidget {
  const HeatmapSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intensities = ref.watch(last60DaysIntensityProvider);

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
                      final index = (weekIndex * 7) + dayIndex;
                      // Ensure we don't go out of bounds of 60 days
                      if (index >= 60) return const Padding(padding: EdgeInsets.only(bottom: 6), child: SizedBox(width: 12, height: 12));
                      
                      final intensity = intensities[59 - index];
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

  Color _getColorForIntensity(double intensity) {
    if (intensity <= 0.05) return AppColors.bgSurface;
    return AppColors.accentGreen.withOpacity(intensity.clamp(0.1, 1.0));
  }
}
