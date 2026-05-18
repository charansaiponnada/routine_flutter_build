import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/daily_log.dart';
import '../models/routine_block.dart';
import '../models/habit_entry.dart';
import '../models/workout_entry.dart';
import '../shared/services/hive_service.dart';
import '../core/constants/routine_data.dart';

part 'daily_log_provider.g.dart';

@riverpod
class DailyLogNotifier extends _$DailyLogNotifier {
  @override
  DailyLog build() {
    final now = DateTime.now();
    final key = _getDateKey(now);
    final existingLog = HiveService.getDailyLog(key);

    if (existingLog != null) {
      return existingLog;
    }

    // Initialize new log for today if it doesn't exist
    final newLog = DailyLog(
      date: DateTime(now.year, now.month, now.day),
      routineStatuses: RoutineData.defaultBlocks.map((b) {
        return RoutineBlockStatus(blockId: b.blockId);
      }).toList(),
    );
    
    // Save immediately so it's persisted
    HiveService.saveDailyLog(newLog);
    return newLog;
  }

  String _getDateKey(DateTime date) => 
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  /// Update a habit check-in
  void updateHabit(String habitId, dynamic value) {
    final habits = [...state.habits];
    final index = habits.indexWhere((h) => h.habitId == habitId);

    if (index != -1) {
      habits[index] = HabitEntry(
        habitId: habitId,
        value: value,
        timestamp: DateTime.now(),
      );
    } else {
      habits.add(HabitEntry(
        habitId: habitId,
        value: value,
        timestamp: DateTime.now(),
      ));
    }

    state = state..habits = habits;
    _save();
  }

  /// Update a routine block status
  void updateRoutineStatus(String blockId, String status, {int? actualDuration}) {
    final statuses = [...state.routineStatuses];
    final index = statuses.indexWhere((s) => s.blockId == blockId);

    if (index != -1) {
      statuses[index] = RoutineBlockStatus(
        blockId: blockId,
        status: status,
        actualDurationMinutes: actualDuration,
      );
      state = state..routineStatuses = statuses;
      _save();
    }
  }

  /// Update journal notes
  void updateNotes({String? morning, String? evening}) {
    state = state
      ..morningNote = morning ?? state.morningNote
      ..eveningNote = evening ?? state.eveningNote;
    _save();
  }

  /// Update workout entry
  void updateWorkout(WorkoutEntry workout) {
    state = state..workout = workout;
    _save();
  }

  void _save() {
    HiveService.saveDailyLog(state);
    // Trigger state refresh for listeners
    state = state;
  }
}
