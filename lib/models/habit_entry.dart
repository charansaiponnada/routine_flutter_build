import 'package:hive/hive.dart';

part 'habit_entry.g.dart';

/// A single habit check-in entry.
/// Embedded within DailyLog.
@HiveType(typeId: 1)
class HabitEntry extends HiveObject {
  @HiveField(0)
  final String habitId;

  @HiveField(1)
  final dynamic value; // bool for check-ins, int/double for counters

  @HiveField(2)
  final DateTime timestamp;

  HabitEntry({
    required this.habitId,
    required this.value,
    required this.timestamp,
  });
}
