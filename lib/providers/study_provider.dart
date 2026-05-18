import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';
import '../models/study_entry.dart';

part 'study_provider.g.dart';

@riverpod
class StudyNotifier extends _$StudyNotifier {
  @override
  List<StudyEntry> build() {
    // Collect all study sessions from all daily logs
    final allSessions = <StudyEntry>[];
    final logs = HiveService.dailyLogBox.values;
    for (final log in logs) {
      allSessions.addAll(log.studySessions);
    }
    return allSessions;
  }

  double getSubjectProgress(String subjectId) {
    // In a real app, this would compare against a total topic list
    // For MVP, we calculate total minutes logged
    final totalMinutes = state
        .where((s) => s.subjectId == subjectId)
        .fold(0, (prev, element) => prev + element.durationMinutes);
    
    // Assume 1000 minutes = 100% for visualization
    return (totalMinutes / 1000).clamp(0.0, 1.0);
  }

  void addStudySession(StudyEntry session) {
    // Note: In our embedded model, we must update the specific DailyLog
    final key = "${session.date.year}-${session.date.month.toString().padLeft(2, '0')}-${session.date.day.toString().padLeft(2, '0')}";
    final log = HiveService.getDailyLog(key);
    
    if (log != null) {
      log.studySessions.add(session);
      HiveService.saveDailyLog(log);
      state = [...state, session];
    }
  }
}
