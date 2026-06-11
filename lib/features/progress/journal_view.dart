import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/daily_log_provider.dart';
import '../../shared/services/hive_service.dart';
import '../../models/daily_log.dart';
import '../../shared/widgets/app_card.dart';

class JournalView extends ConsumerWidget {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);
    
    // Fetch all logs that have any notes
    final historyLogs = HiveService.dailyLogBox.values
        .where((l) => (l.morningNote != null && l.morningNote!.isNotEmpty) || 
                      (l.eveningNote != null && l.eveningNote!.isNotEmpty))
        .toList();
    historyLogs.sort((a, b) => b.date.compareTo(a.date));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: AppConstants.fastAnim,
            child: _buildJournalInput(
              context,
              title: 'MORNING REFLECTION',
              prompt: 'What would make today a win?',
              value: dailyLog.morningNote ?? '',
              onChanged: (val) => notifier.updateNotes(morning: val),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            child: _buildJournalInput(
              context,
              title: 'NIGHT REVIEW',
              prompt: 'Did you earn sleep?',
              value: dailyLog.eveningNote ?? '',
              onChanged: (val) => notifier.updateNotes(evening: val),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: AppConstants.mediumAnim,
            child: Text(
              'HISTORY',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          if (historyLogs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No past reflections yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
              ),
            )
          else
            ...historyLogs.asMap().entries.map((entry) => _buildHistoryItem(context, entry.value, entry.key)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, DailyLog log, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FadeInLeft(
        duration: AppConstants.fastAnim,
        delay: Duration(milliseconds: index * 50),
        child: AppCard(
          color: AppColors.bgSurface,
          showShadow: false,
          onTap: () => _showLogDetail(context, log),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy').format(log.date),
                    style: AppTheme.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      log.morningNote ?? log.eveningNote ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetail(BuildContext context, DailyLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text(DateFormat('EEEE, MMM d').format(log.date)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.morningNote != null && log.morningNote!.isNotEmpty) ...[
                const Text('MORNING REFLECTION', style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                const SizedBox(height: 4),
                Text(log.morningNote!),
                const SizedBox(height: 16),
              ],
              if (log.eveningNote != null && log.eveningNote!.isNotEmpty) ...[
                const Text('NIGHT REVIEW', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 10)),
                const SizedBox(height: 4),
                Text(log.eveningNote!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalInput(
    BuildContext context, {
    required String title,
    required String prompt,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5, fontSize: 12),
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  prompt,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGreen,
                      ),
                ),
              ),
              TextField(
                onChanged: onChanged,
                maxLines: 4,
                maxLength: 300,
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Start writing...',
                  counterStyle: AppTheme.jetBrainsMono(fontSize: 10),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
