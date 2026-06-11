import 'package:hive_flutter/hive_flutter.dart';
import '../../models/daily_log.dart';
import '../../models/habit_entry.dart';
import '../../models/study_entry.dart';
import '../../models/workout_entry.dart';
import '../../models/routine_block.dart';
import '../../models/course_progress.dart';
import '../../core/constants/app_constants.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DailyLogAdapter());
    Hive.registerAdapter(HabitEntryAdapter());
    Hive.registerAdapter(StudyEntryAdapter());
    Hive.registerAdapter(WorkoutEntryAdapter());
    Hive.registerAdapter(RoutineBlockStatusAdapter());
    Hive.registerAdapter(RoutineBlockAdapter());
    Hive.registerAdapter(CourseProgressAdapter());

    await Hive.openBox<DailyLog>(AppConstants.dailyLogsBox);
    await Hive.openBox<RoutineBlock>(AppConstants.routineBlocksBox);
    await Hive.openBox<CourseProgress>(AppConstants.courseProgressBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  static Box<RoutineBlock> get routineBlockBox =>
      Hive.box<RoutineBlock>(AppConstants.routineBlocksBox);

  static List<RoutineBlock> getRoutineBlocks() {
    if (routineBlockBox.isEmpty) return [];
    return routineBlockBox.values.toList();
  }

  static Future<void> saveRoutineBlocks(List<RoutineBlock> blocks) async {
    await routineBlockBox.clear();
    await routineBlockBox.addAll(blocks);
  }

  static Box<DailyLog> get dailyLogBox =>
      Hive.box<DailyLog>(AppConstants.dailyLogsBox);

  static DailyLog? getDailyLog(String key) => dailyLogBox.get(key);

  static Future<void> saveDailyLog(DailyLog log) async {
    await dailyLogBox.put(log.keyId, log);
  }

  static Box get settingsBox => Hive.box(AppConstants.settingsBox);

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static Future<void> clearAllData() async {
    await dailyLogBox.clear();
    await settingsBox.clear();
  }
}
