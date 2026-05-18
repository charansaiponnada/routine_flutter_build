import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/greeting_header.dart';
import 'widgets/progress_ring_card.dart';
import 'widgets/today_stats_row.dart';
import 'widgets/heatmap_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: AppConstants.fastAnim,
                child: const GreetingHeader(),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: AppConstants.mediumAnim,
                child: const ProgressRingCard(percent: 0.75), // Mock percent
              ),
              const SizedBox(height: 24),
              FadeInUp(
                duration: AppConstants.mediumAnim,
                delay: const Duration(milliseconds: 100),
                child: const TodayStatsRow(),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                duration: AppConstants.slowAnim,
                delay: const Duration(milliseconds: 200),
                child: const HeatmapSection(),
              ),
              const SizedBox(height: 32),
              _buildQuoteSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection(BuildContext context) {
    final quote = AppConstants.quotes[DateTime.now().day % AppConstants.quotes.length];
    return FadeInUp(
      duration: AppConstants.slowAnim,
      delay: const Duration(milliseconds: 300),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '"$quote"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
