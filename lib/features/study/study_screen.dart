import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/gate_subjects.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/study_provider.dart';
import '../../models/study_entry.dart';
import '../../models/mock_test.dart';
import '../../shared/services/hive_service.dart';
import 'widgets/subject_progress_card.dart';
import 'widgets/mock_test_tile.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(studyNotifierProvider);
    final studyNotifier = ref.read(studyNotifierProvider.notifier);
    final mockTests = HiveService.getAllMockTests();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GATE DA 2027',
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
            Text(
              'SUBJECT COVERAGE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
            ),
            const SizedBox(height: 16),
            ...GateSubjects.subjects.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              final progress = studyNotifier.getSubjectProgress(subject['id']);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FadeInLeft(
                  duration: AppConstants.fastAnim,
                  delay: Duration(milliseconds: index * 50),
                  child: SubjectProgressCard(
                    name: subject['name'],
                    weightage: subject['weightage'],
                    progress: progress,
                    onTap: () => _showLogStudyDialog(context, subject, studyNotifier),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MOCK TESTS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 1.5),
                ),
                TextButton.icon(
                  onPressed: () => _showAddMockTestDialog(context, ref),
                  icon: const Icon(Icons.add, size: 18, color: AppColors.accentGreen),
                  label: Text(
                    'LOG SCORE',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (mockTests.isEmpty)
              FadeIn(
                duration: AppConstants.slowAnim,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(Icons.quiz_outlined, size: 48, color: AppColors.textMuted.withAlpha(50)),
                        const SizedBox(height: 16),
                        Text(
                          'No mock tests logged yet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your journey to AIR < 100 starts with a test.',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...mockTests.reversed.map((test) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MockTestTile(test: test),
              )),
          ],
        ),
      ),
    );
  }

  void _showLogStudyDialog(BuildContext context, Map<String, dynamic> subject, StudyNotifier notifier) {
    final topicController = TextEditingController();
    double duration = 60;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text('Log ${subject['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                hintText: 'What topic did you cover?',
              ),
            ),
            const SizedBox(height: 24),
            StatefulBuilder(
              builder: (context, setModalState) => Column(
                children: [
                  Text(
                    '${duration.toInt()} MINS',
                    style: AppTheme.jetBrainsMono(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentCyan,
                    ),
                  ),
                  Slider(
                    value: duration,
                    min: 15,
                    max: 240,
                    divisions: 15,
                    activeColor: AppColors.accentCyan,
                    onChanged: (val) => setModalState(() => duration = val),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan),
            onPressed: () {
              if (topicController.text.isNotEmpty) {
                notifier.addStudySession(StudyEntry(
                  subjectId: subject['id'],
                  topicName: topicController.text,
                  durationMinutes: duration.toInt(),
                  date: DateTime.now(),
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddMockTestDialog(BuildContext context, WidgetRef ref) {
    final scoreController = TextEditingController();
    final totalController = TextEditingController(text: '100');
    final subjectController = TextEditingController(text: 'Full Mock');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: const Text('Log Mock Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(hintText: 'Test Name / Subject'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Score'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Total'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
            onPressed: () async {
              if (scoreController.text.isNotEmpty && totalController.text.isNotEmpty) {
                final score = double.parse(scoreController.text);
                final total = double.parse(totalController.text);
                final percentile = (score / total) * 100;

                await HiveService.addMockTest(MockTest(
                  date: DateTime.now(),
                  score: score,
                  totalMarks: total,
                  subject: subjectController.text,
                  percentileEstimate: percentile,
                ));
                // We need to trigger a rebuild, for now we just pop
                // In a full implementation, we'd use a provider for MockTests too
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
