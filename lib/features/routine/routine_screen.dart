import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/routine_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/daily_log_provider.dart';
import '../../models/routine_block.dart';
import 'widgets/routine_block_tile.dart';

import '../../providers/settings_provider.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);
    final settings = ref.watch(settingsNotifierProvider);
    final blocks = (settings['routineBlocks'] as List<RoutineBlock>?) ?? RoutineData.defaultBlocks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAILY ROUTINE',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: blocks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm_off_rounded, size: 64, color: AppColors.textMuted.withAlpha(50)),
                  const SizedBox(height: 16),
                  Text(
                    'No routine blocks defined.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set up your 4 AM discipline in Settings.',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
                vertical: AppConstants.verticalPadding,
              ),
              itemCount: blocks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final block = blocks[index];
                final status = dailyLog.routineStatuses.firstWhere(
                  (s) => s.blockId == block.blockId,
                  orElse: () => RoutineBlockStatus(blockId: block.blockId),
                );

                final bool isActive = _isBlockActive(block);

                return FadeInUp(
                  duration: AppConstants.fastAnim,
                  delay: Duration(milliseconds: index * 50),
                  child: RoutineBlockTile(
                    block: block,
                    status: status,
                    isActive: isActive,
                    onDone: () => notifier.updateRoutineStatus(block.blockId, 'done'),
                    onSkipped: () => notifier.updateRoutineStatus(block.blockId, 'skipped'),
                    onPartial: () => _showPartialBottomSheet(context, block, notifier),
                  ),
                );
              },
            ),
    );
  }

  bool _isBlockActive(RoutineBlock block) {
    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm').format(now);
    
    // Simple string comparison for HH:mm
    // Handles cross-midnight by checking the block startTime and endTime
    if (block.startTime.compareTo(block.endTime) > 0) {
      // Cross-midnight block (e.g., 21:30 - 04:00)
      return currentTime.compareTo(block.startTime) >= 0 || currentTime.compareTo(block.endTime) < 0;
    } else {
      return currentTime.compareTo(block.startTime) >= 0 && currentTime.compareTo(block.endTime) < 0;
    }
  }

  void _showPartialBottomSheet(BuildContext context, RoutineBlock block, DailyLogNotifier notifier) {
    double duration = 30;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Partial Completion',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'How many minutes did you spend on ${block.name}?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '${duration.toInt()} MINS',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentAmber,
                    ),
                  ),
                  Slider(
                    value: duration,
                    min: 0,
                    max: 180,
                    divisions: 36,
                    activeColor: AppColors.accentAmber,
                    inactiveColor: AppColors.bgElevated,
                    onChanged: (val) => setModalState(() => duration = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentAmber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        notifier.updateRoutineStatus(
                          block.blockId,
                          'partial',
                          actualDuration: duration.toInt(),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('LOG PARTIAL PROGRESS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
