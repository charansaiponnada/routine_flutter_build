import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../core/constants/habit_data.dart';

class HabitCard extends StatelessWidget {
  final HabitDefinition definition;
  final dynamic value;
  final Function(dynamic) onChanged;

  const HabitCard({
    super.key,
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _isCompleted();

    return AppCard(
      color: isCompleted ? AppColors.accentGreen.withAlpha(20) : AppColors.bgCard,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.accentGreen.withAlpha(40) : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              definition.icon,
              color: isCompleted ? AppColors.accentGreen : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                if (definition.type != HabitType.boolean)
                  Text(
                    '${value ?? 0} ${definition.unit}',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 12,
                      color: isCompleted ? AppColors.accentGreen : AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          _buildActionWidget(),
        ],
      ),
    );
  }

  bool _isCompleted() {
    if (definition.type == HabitType.boolean) {
      return value == true;
    }
    return (value ?? 0) > 0;
  }

  Widget _buildActionWidget() {
    if (definition.type == HabitType.boolean) {
      return Switch.adaptive(
        value: value == true,
        activeColor: AppColors.accentGreen,
        onChanged: onChanged,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconButton(
            icon: Icons.remove,
            onTap: () {
              final current = (value ?? 0) as num;
              final step = definition.step ?? 1;
              if (current >= step) onChanged(current - step);
            },
          ),
          const SizedBox(width: 8),
          _IconButton(
            icon: Icons.add,
            onTap: () {
              final current = (value ?? 0) as num;
              final step = definition.step ?? 1;
              onChanged(current + step);
            },
          ),
        ],
      );
    }
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}
