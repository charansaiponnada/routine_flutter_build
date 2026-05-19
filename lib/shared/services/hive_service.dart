import 'package:hive_flutter/hive_flutter.dart';
import '../../models/daily_log.dart';
import '../../models/habit_entry.dart';
import '../../models/study_entry.dart';
import '../../models/workout_entry.dart';
import '../../models/routine_block.dart';
import '../../models/mock_test.dart';
import '../../core/constants/app_constants.dart';

/// HiveService manages initialization and CRUD operations for Hive boxes.
class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(DailyLogAdapter());
    Hive.registerAdapter(HabitEntryAdapter());
    Hive.registerAdapter(StudyEntryAdapter());
    Hive.registerAdapter(WorkoutEntryAdapter());
    Hive.registerAdapter(RoutineBlockStatusAdapter());
    Hive.registerAdapter(RoutineBlockAdapter());
    Hive.registerAdapter(MockTestAdapter());

    // Open Boxes
    await Hive.openBox<DailyLog>(AppConstants.dailyLogsBox);
    await Hive.openBox<MockTest>(AppConstants.mockTestsBox);
    await Hive.openBox<RoutineBlock>(AppConstants.routineBlocksBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  // --- Routine Block Operations ---

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

  // --- DailyLog Operations ---

  static Box<DailyLog> get dailyLogBox =>
      Hive.box<DailyLog>(AppConstants.dailyLogsBox);

  static DailyLog? getDailyLog(String key) => dailyLogBox.get(key);

  static Future<void> saveDailyLog(DailyLog log) async {
    await dailyLogBox.put(log.keyId, log);
  }

  // --- Mock Test Operations ---

  static Box<MockTest> get mockTestBox =>
      Hive.box<MockTest>(AppConstants.mockTestsBox);

  static List<MockTest> getAllMockTests() => mockTestBox.values.toList();

  static Future<void> addMockTest(MockTest test) async {
    await mockTestBox.add(test);
  }

  // --- Settings Operations ---

  static Box get settingsBox => Hive.box(AppConstants.settingsBox);

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static Future<void> clearAllData() async {
    await dailyLogBox.clear();
    await mockTestBox.clear();
    await settingsBox.clear();
  }
}
