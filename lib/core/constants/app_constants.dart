/// App-wide constants for ForgeRoutine.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'ForgeRoutine';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String dailyLogsBox = 'daily_logs';
  static const String habitEntriesBox = 'habit_entries';
  static const String studyEntriesBox = 'study_entries';
  static const String workoutEntriesBox = 'workout_entries';
  static const String routineBlocksBox = 'routine_blocks';
  static const String mockTestsBox = 'mock_tests';
  static const String settingsBox = 'settings';

  // Animation Durations
  static const Duration fastAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 400);
  static const Duration slowAnim = Duration(milliseconds: 600);

  // UI Constraints
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 16.0;
  static const double cardRadius = 12.0;

  // External Links
  static const String githubRepoUrl = 'https://github.com/charansaiponnada/forge_routine';

  // Hardcoded Motivational Quotes
  static const List<String> quotes = [
    "No more hoping. Only forging.",
    "4 AM. Your future self is already awake.",
    "Discipline is the bridge between goals and accomplishment.",
    "The pain of discipline is far less than the pain of regret.",
    "Show up when you don't feel like it. Especially then.",
    "GATE DA 2027 is won in the quiet hours.",
    "Greatness is a series of small wins repeated daily.",
    "Your routine is your armor. Wear it.",
    "One day or Day One. You decide.",
    "Suffer the work now, live the dream later.",
    "Don't stop when you're tired. Stop when you're done.",
    "Consistency beats intensity every single time.",
    "The only way out is through.",
    "Focus is the new IQ.",
    "Win the morning, win the day.",
  ];
}
