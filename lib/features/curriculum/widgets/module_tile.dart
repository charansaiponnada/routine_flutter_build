import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/curriculum.dart';
import '../../../shared/widgets/app_card.dart';

class ModuleTile extends StatelessWidget {
  final CourseModule module;
  final bool isCompleted;
  final VoidCallback onToggle;
  final int index;

  const ModuleTile({
    super.key,
    required this.module,
    required this.isCompleted,
    required this.onToggle,
    required this.index,
  });

  Future<void> _openVideo() async {
    if (module.videoUrl != null) {
      final uri = Uri.tryParse(module.videoUrl!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onToggle,
      color: isCompleted ? AppColors.accentGreen.withAlpha(8) : AppColors.bgCard,
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.accentGreen : AppColors.textMuted,
                  width: 2,
                ),
                color: isCompleted ? AppColors.accentGreen : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ${module.title}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                if (module.estimatedMinutes > 0)
                  Text(
                    '~${module.estimatedMinutes} min',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (module.videoUrl != null)
            IconButton(
              onPressed: _openVideo,
              icon: const Icon(Icons.play_circle_outline, size: 22),
              color: AppColors.accentCyan,
              tooltip: 'Open video',
            ),
        ],
      ),
    );
  }
}
