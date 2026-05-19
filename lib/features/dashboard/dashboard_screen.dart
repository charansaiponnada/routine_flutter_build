import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/streak_provider.dart';
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
    
    // Check for streak milestones after build
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
