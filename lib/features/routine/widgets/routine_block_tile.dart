import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/routine_block.dart';
import '../../../shared/widgets/app_card.dart';

class RoutineBlockTile extends StatelessWidget {
  final RoutineBlock block;
  final RoutineBlockStatus status;
  final bool isActive;
  final VoidCallback onDone;
  final VoidCallback onPartial;
  final VoidCallback onSkipped;

  const RoutineBlockTile({
    super.key,
    required this.block,
    required this.status,
    this.isActive = false,
    required this.onDone,
    required this.onPartial,
    required this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.status == 'done';
    final bool isPartial = status.status == 'partial';
    final bool isSkipped = status.status == 'skipped';

    return AppCard(
      padding: const EdgeInsets.all(12),
      color: isActive ? AppColors.accentGreen.withAlpha(10) : AppColors.bgCard,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${block.startTime} - ${block.endTime}',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 12,
                      color: isActive ? AppColors.accentGreen : AppColors.textMuted,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    block.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      color: isActive ? AppColors.accentGreen : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatusButton(
                label: 'Done',
                icon: Icons.check_circle_rounded,
                color: AppColors.accentGreen,
                isSelected: isCompleted,
                onTap: onDone,
              ),
              const SizedBox(width: 8),
              _StatusButton(
                label: 'Partial',
                icon: Icons.remove_circle_rounded,
                color: AppColors.accentAmber,
                isSelected: isPartial,
                onTap: onPartial,
              ),
              const SizedBox(width: 8),
              _StatusButton(
                label: 'Skipped',
                icon: Icons.cancel_rounded,
                color: AppColors.accentRed,
                isSelected: isSkipped,
                onTap: onSkipped,
              ),
            ],
          ),
          if (isPartial && status.actualDurationMinutes != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Logged: ${status.actualDurationMinutes} mins',
                  style: AppTheme.jetBrainsMono(
                    fontSize: 11,
                    color: AppColors.accentAmber,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(40) : AppColors.bgSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppColors.borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? color : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? color : AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
