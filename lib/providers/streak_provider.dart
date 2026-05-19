import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';
import '../models/daily_log.dart';
import 'daily_log_provider.dart';

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
  
  final mockTests = HiveService.getAllMockTests();
  final currentMonthMocks = mockTests.where((m) => m.date.month == now.month && m.date.year == now.year).toList();
  final avgScore = currentMonthMocks.isEmpty 
      ? 0.0 
      : currentMonthMocks.fold<double>(0, (sum, m) => sum + (m.score / m.totalMarks)) / currentMonthMocks.length;
      
  final totalWorkouts = currentMonthLogs.where((l) => l.workout?.isCompleted == true).length;
  
  return {
    'study': '${(totalStudyMinutes / 60).toStringAsFixed(0)}h',
    'score': '${(avgScore * 100).toStringAsFixed(0)}%',
    'workouts': '$totalWorkouts',
  };
}