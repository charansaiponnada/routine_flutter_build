import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/curriculum.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/streak_provider.dart';
import '../../providers/curriculum_provider.dart';
import '../../shared/widgets/app_card.dart';
import 'widgets/greeting_header.dart';
import 'widgets/progress_ring_card.dart';
import 'widgets/today_stats_row.dart';
import 'widgets/heatmap_section.dart';
import 'widgets/habit_checkin_row.dart';

import 'package:confetti/confetti.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final streak = ref.read(currentStreakProvider);
      if (streak > 0 && (streak == 7 || streak == 30 || streak % 100 == 0)) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    child: ProgressRingCard(
                      percent: ref.watch(todayCompletionProgressProvider),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    duration: AppConstants.mediumAnim,
                    delay: const Duration(milliseconds: 50),
                    child: const HabitCheckinRow(),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    duration: AppConstants.mediumAnim,
                    delay: const Duration(milliseconds: 100),
                    child: const TodayStatsRow(),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    duration: AppConstants.mediumAnim,
                    delay: const Duration(milliseconds: 150),
                    child: const _CurrentFocusCard(),
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
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [AppColors.accentGreen, AppColors.accentCyan],
                shouldLoop: false,
              ),
            ),
          ],
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

class _CurrentFocusCard extends ConsumerWidget {
  const _CurrentFocusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(curriculumNotifierProvider.notifier);
    RoadmapCourse? focus;
    double minProgress = 1.0;

    for (final course in Curriculum.courses) {
      final p = notifier.getProgress(course.id);
      if (p < 1.0 && p <= minProgress) {
        minProgress = p;
        focus = course;
      }
    }

    if (focus == null) return const SizedBox.shrink();

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
              body: const Center(child: Text('Navigate to course detail')),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.track_changes, color: AppColors.accentGreen, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT FOCUS',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  focus.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: minProgress,
                    backgroundColor: AppColors.bgElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(minProgress * 100).toInt()}%',
            style: AppTheme.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.accentGreen,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
