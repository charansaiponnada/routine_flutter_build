import 'package:flutter/material.dart';
import '../../../core/constants/curriculum.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';

class CourseCard extends StatelessWidget {
  final RoadmapCourse course;
  final double progress;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.progress,
    required this.onTap,
  });

  IconData _iconData() {
    switch (course.icon) {
      case 'functions': return Icons.functions;
      case 'smart_display': return Icons.smart_display;
      case 'insights': return Icons.insights;
      case 'bolt': return Icons.bolt;
      case 'linear_scale': return Icons.linear_scale;
      case 'school': return Icons.school;
      case 'workspace_premium': return Icons.workspace_premium;
      default: return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGate = course.type == CourseType.gate;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconData(), color: AppColors.accentGreen, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isGate ? AppColors.accentAmber.withAlpha(40) : AppColors.accentCyan.withAlpha(40),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isGate ? 'GATE' : 'ROADMAP',
                        style: AppTheme.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isGate ? AppColors.accentAmber : AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGate ? AppColors.accentAmber : AppColors.accentGreen,
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${course.totalModules} modules · ${(progress * 100).toInt()}%',
            style: AppTheme.jetBrainsMono(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
