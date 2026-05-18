import 'package:hive/hive.dart';
import 'habit_entry.dart';
import 'study_entry.dart';
import 'workout_entry.dart';
import 'routine_block.dart';

part 'daily_log.g.dart';

/// The Aggregate Root for a single day's data.
/// Stored in 'daily_logs' box with key: yyyy-MM-dd.
@HiveType(typeId: 0)
class DailyLog extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  List<HabitEntry> habits;

  @HiveField(2)
  List<StudyEntry> studySessions;

  @HiveField(3)
  WorkoutEntry? workout;

  @HiveField(4)
  List<RoutineBlockStatus> routineStatuses;

  @HiveField(5)
  bool allHabitsCompleted;

  @HiveField(6)
  int streakCount;

  @HiveField(7)
  String? morningNote; // "What would make today a win?"

  @HiveField(8)
  String? eveningNote; // "Did you earn sleep?"

  DailyLog({
    required this.date,
    this.habits = const [],
    this.studySessions = const [],
    this.workout,
    this.routineStatuses = const [],
    this.allHabitsCompleted = false,
    this.streakCount = 0,
    this.morningNote,
    this.eveningNote,
  });

  /// Formatted date string used as Hive key
  String get keyId => "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
