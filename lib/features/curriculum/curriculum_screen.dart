import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/curriculum.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/curriculum_provider.dart';
import 'widgets/course_card.dart';
import 'widgets/module_tile.dart';

class CurriculumScreen extends ConsumerWidget {
  const CurriculumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LEARNING PATH',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.verticalPadding,
        ),
        children: [
          FadeInDown(
            duration: AppConstants.fastAnim,
            child: _buildOverallProgress(context, ref),
          ),
          const SizedBox(height: 24),
          Text(
            'COURSES',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          ...Curriculum.courses.asMap().entries.map((entry) {
            final index = entry.key;
            final course = entry.value;
            final progress = ref.watch(curriculumNotifierProvider.notifier).getProgress(course.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FadeInLeft(
                duration: AppConstants.fastAnim,
                delay: Duration(milliseconds: index * 50),
                child: CourseCard(
                  course: course,
                  progress: progress,
                  onTap: () => _openCourseDetail(context, ref, course),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(BuildContext context, WidgetRef ref) {
    final overallProgress = ref.watch(overallCurriculumProgressProvider);
    final totalCompleted = ref.watch(totalModulesCompletedProvider);
    final totalModules = Curriculum.courses.fold<int>(0, (s, c) => s + c.totalModules);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: AppColors.accentGreen.withAlpha(30)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: overallProgress,
                  strokeWidth: 5,
                  backgroundColor: AppColors.bgElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                ),
                Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curriculum Progress',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalCompleted / $totalModules modules completed',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCourseDetail(BuildContext context, WidgetRef ref, RoadmapCourse course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CourseDetailScreen(course: course),
      ),
    );
  }
}

class _CourseDetailScreen extends ConsumerWidget {
  final RoadmapCourse course;

  const _CourseDetailScreen({required this.course});

  Future<void> _openPlaylist() async {
    if (course.playlistUrl != null) {
      final uri = Uri.tryParse(course.playlistUrl!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(curriculumNotifierProvider.notifier);
    final progress = notifier.getProgress(course.id);
    final completed = notifier.completedCount(course.id);
    final isGate = course.type == CourseType.gate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        children: [
          FadeInDown(
            duration: AppConstants.fastAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isGate ? AppColors.accentAmber.withAlpha(40) : AppColors.accentCyan.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isGate ? 'GATE' : 'ROADMAP',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isGate ? AppColors.accentAmber : AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: AppTheme.jetBrainsMono(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isGate ? AppColors.accentAmber : AppColors.accentGreen,
                            ),
                          ),
                          Text(
                            'COMPLETE',
                            style: AppTheme.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$completed / ${course.totalModules}',
                          style: AppTheme.jetBrainsMono(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentCyan,
                          ),
                        ),
                        Text(
                          'MODULES DONE',
                          style: AppTheme.jetBrainsMono(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    if (course.playlistUrl != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _openPlaylist,
                        icon: const Icon(Icons.play_circle_filled),
                        color: AppColors.accentGreen,
                        tooltip: 'Open playlist',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.bgElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isGate ? AppColors.accentAmber : AppColors.accentGreen,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'MODULES',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          ...course.modules.asMap().entries.map((entry) {
            final index = entry.key;
            final module = entry.value;
            final completed = notifier.isModuleCompleted(course.id, module.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FadeInLeft(
                duration: AppConstants.fastAnim,
                delay: Duration(milliseconds: index * 30),
                child: ModuleTile(
                  module: module,
                  isCompleted: completed,
                  index: index,
                  onToggle: () => notifier.toggleModule(course.id, module.id),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
