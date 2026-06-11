import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:forge_routine/models/daily_log.dart';
import 'package:forge_routine/models/habit_entry.dart';
import 'package:forge_routine/models/study_entry.dart';
import 'package:forge_routine/models/workout_entry.dart';
import 'package:forge_routine/models/routine_block.dart';
import 'package:forge_routine/models/course_progress.dart';

void main() {
  test('Hive init and adapter registration', () {
    Hive.init('test/_hive');
    Hive.registerAdapter(DailyLogAdapter());
    Hive.registerAdapter(HabitEntryAdapter());
    Hive.registerAdapter(StudyEntryAdapter());
    Hive.registerAdapter(WorkoutEntryAdapter());
    Hive.registerAdapter(RoutineBlockStatusAdapter());
    Hive.registerAdapter(RoutineBlockAdapter());
    Hive.registerAdapter(CourseProgressAdapter());
    expect(true, isTrue);
  });
}
