import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/streak_provider.dart';
import 'widgets/study_hours_chart.dart';
import 'widgets/streak_chart.dart';
import 'widgets/habit_radar_chart.dart';
import '../../shared/widgets/app_card.dart';

import 'journal_view.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INSIGHTS HUB',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.accentGreen,
          labelColor: AppColors.accentGreen,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: AppTheme.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'ANALYTICS'),
            Tab(text: 'JOURNAL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalyticsView(context, ref),
          const JournalView(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            duration: AppConstants.fastAnim,
            child: const StudyHoursChart(),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            delay: const Duration(milliseconds: 100),
            child: const StreakChart(),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            delay: const Duration(milliseconds: 200),
            child: const HabitRadarChart(),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: AppConstants.slowAnim,
            delay: const Duration(milliseconds: 300),
            child: _buildMonthlySummaryCard(context, ref),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMonthlySummaryCard(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(monthlySummaryProvider);
    final monthName = DateFormat('MMMM').format(DateTime.now()).toUpperCase();

    return AppCard(
      color: AppColors.bgSurface,
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY OVERVIEW ($monthName)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryStat(context, 'Study', summary['study']!, AppColors.accentCyan),
              _buildSummaryStat(context, 'Avg Score', summary['score']!, AppColors.accentGreen),
              _buildSummaryStat(context, 'Workouts', summary['workouts']!, AppColors.accentAmber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTheme.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
