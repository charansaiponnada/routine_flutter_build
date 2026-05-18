import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/daily_log_provider.dart';
import '../../shared/widgets/app_card.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLog = ref.watch(dailyLogNotifierProvider);
    final notifier = ref.read(dailyLogNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAILY JOURNAL',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildJournalHistory(context),
          ],
        ),
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
          style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJournalHistory(BuildContext context) {
    // For now, we'll just show a placeholder list. 
    // In a full implementation, we'd fetch past logs from Hive.
    return Column(
      children: List.generate(3, (index) {
        final date = DateTime.now().subtract(Duration(days: index + 1));
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FadeInLeft(
            duration: AppConstants.fastAnim,
            delay: Duration(milliseconds: index * 100),
            child: AppCard(
              color: AppColors.bgSurface,
              showShadow: false,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d, yyyy').format(date),
                        style: AppTheme.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reflections recorded...',
                        style: Theme.of(context).textTheme.bodySmall,
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
      }),
    );
  }
}
