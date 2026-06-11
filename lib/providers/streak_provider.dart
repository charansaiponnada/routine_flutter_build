import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';
import '../models/daily_log.dart';
import '../models/habit_entry.dart';
import '../core/constants/curriculum.dart';
import 'daily_log_provider.dart';
import 'curriculum_provider.dart';

part 'streak_provider.g.dart';

@riverpod
int currentStreak(CurrentStreakRef ref) {
  final logs = HiveService.dailyLogBox.values.toList();
  if (logs.isEmpty) return 0;

  // Sort logs by date descending
  logs.sort((a, b) => b.date.compareTo(a.date));

  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  
  int streak = 0;
  DateTime checkDate = todayStart;

  // If today isn't started yet, we might want to check from yesterday
  // But for this app, we'll check if today is active or if yesterday was the last win
  
  for (final log in logs) {
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    
    if (logDate == checkDate) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else if (logDate.isBefore(checkDate)) {
      // If we are checking today and it's missing, maybe yesterday was the last win
      if (checkDate == todayStart) {
        checkDate = checkDate.subtract(const Duration(days: 1));
        if (logDate == checkDate) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
      }
      break;
    }
  }

  return streak;
}

@riverpod
double todayCompletionProgress(TodayCompletionProgressRef ref) {
  final log = ref.watch(dailyLogNotifierProvider);
  if (log.routineStatuses.isEmpty) return 0.0;

  final doneCount = log.routineStatuses.where((s) => s.status == 'done').length;
  final partialCount = log.routineStatuses.where((s) => s.status == 'partial').length;
  
  return (doneCount + (partialCount * 0.5)) / log.routineStatuses.length;
}

@riverpod
List<double> last60DaysIntensity(Last60DaysIntensityRef ref) {
  final logs = HiveService.dailyLogBox.values.toList();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  final intensities = List<double>.filled(60, 0.0);
  
  for (int i = 0; i < 60; i++) {
    final date = today.subtract(Duration(days: i));
    final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    final log = logs.cast<DailyLog?>().firstWhere(
      (l) => l?.keyId == dateKey,
      orElse: () => null,
    );
    
    if (log != null) {
      // Calculate intensity based on routine and habits
      final routineDone = log.routineStatuses.where((s) => s.status == 'done').length;
      final habitsDone = log.habits.length; // Simplified
      
      final intensity = (routineDone + habitsDone) / 15.0; // Max ~15 points
      intensities[59 - i] = intensity.clamp(0.0, 1.0);
    }
  }
  
  return intensities;
}

@riverpod
Map<String, String> monthlySummary(MonthlySummaryRef ref) {
  final logs = HiveService.dailyLogBox.values.toList();
  final now = DateTime.now();
  final currentMonthLogs = logs.where((l) => l.date.month == now.month && l.date.year == now.year).toList();
  
  if (currentMonthLogs.isEmpty) {
    return {'study': '0h', 'score': '0%', 'workouts': '0'};
  }
  
  final totalStudyMinutes = currentMonthLogs.fold<int>(0, (sum, l) {
    return sum + l.studySessions.fold<int>(0, (sSum, s) => sSum + s.durationMinutes);
  });
  
  final totalWorkouts = currentMonthLogs.where((l) => l.workout?.isCompleted == true).length;
  final notifier = ref.read(curriculumNotifierProvider.notifier);
  final totalCompleted = Curriculum.courses.fold<int>(0, (s, c) => s + notifier.completedCount(c.id));
  
  return {
    'study': '${(totalStudyMinutes / 60).toStringAsFixed(0)}h',
    'score': '${totalCompleted} mod',
    'workouts': '$totalWorkouts',
  };
  }

  @riverpod
  List<double> streakHistory(StreakHistoryRef ref) {
  final logs = HiveService.dailyLogBox.values.toList();
  // Sort by date ascending to calculate streaks forward
  logs.sort((a, b) => a.date.compareTo(b.date));

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final history = List<double>.filled(30, 0.0);

  // We need a wider window to calculate streaks correctly for the start of our 30-day window
  // But for the chart, we just need the values for the last 30 days.

  for (int i = 0; i < 30; i++) {
    final targetDate = today.subtract(Duration(days: 29 - i));

    // Calculate streak as of targetDate
    int streak = 0;
    DateTime checkDate = targetDate;

    // Efficiently find logs for or before checkDate
    final relevantLogs = logs.where((l) => l.date.isBefore(checkDate.add(const Duration(days: 1)))).toList();
    relevantLogs.sort((a, b) => b.date.compareTo(a.date)); // Descending for streak calc

    for (final log in relevantLogs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      if (logDate == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (logDate.isBefore(checkDate)) {
        break;
      }
    }
    history[i] = streak.toDouble();
    }

    return history;
    }

    @riverpod
    List<double> habitRadarStats(HabitRadarStatsRef ref) {
    final logs = HiveService.dailyLogBox.values.toList();
    final now = DateTime.now();
    final last7Days = logs.where((l) => l.date.isAfter(now.subtract(const Duration(days: 7)))).toList();

    if (last7Days.isEmpty) return [0, 0, 0, 0, 0];

    double studyScore = 0;
    double fitnessScore = 0;
    double wakeupScore = 0;
    double codingScore = 0;
    double journalScore = 0;

    for (final log in last7Days) {
    // Study: Target 4 hours per day
    final studyMins = log.studySessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    studyScore += (studyMins / (4 * 60)).clamp(0.0, 1.0);

    // Fitness: Workout completed
    if (log.workout?.isCompleted == true) fitnessScore += 1.0;

    // Wakeup: Boolean habit
    final wakeUp = log.habits.cast<HabitEntry?>().firstWhere((h) => h?.habitId == 'wake_up', orElse: () => null);
    if (wakeUp?.value == true) wakeupScore += 1.0;

    // Coding: LeetCode problems (target 2 per day)
    final coding = log.habits.cast<HabitEntry?>().firstWhere((h) => h?.habitId == 'leetcode', orElse: () => null);
    final codingVal = (coding?.value as num?) ?? 0;
    codingScore += (codingVal / 2.0).clamp(0.0, 1.0);

    // Journal: Both notes filled
    if (log.morningNote != null && log.morningNote!.isNotEmpty) journalScore += 0.5;
    if (log.eveningNote != null && log.eveningNote!.isNotEmpty) journalScore += 0.5;
    }

    return [
    (studyScore / 7).clamp(0.0, 1.0) * 5,
    (fitnessScore / 7).clamp(0.0, 1.0) * 5,
    (wakeupScore / 7).clamp(0.0, 1.0) * 5,
    (codingScore / 7).clamp(0.0, 1.0) * 5,
    (journalScore / 7).clamp(0.0, 1.0) * 5,
    ];
    }