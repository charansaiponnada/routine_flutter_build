import 'package:hive/hive.dart';

part 'workout_entry.g.dart';

/// Daily fitness log.
/// Embedded within DailyLog.
@HiveType(typeId: 3)
class WorkoutEntry extends HiveObject {
  @HiveField(0)
  final bool isCompleted;

  @HiveField(1)
  final String type; // circuit, walk, run

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final List<String> exercises;

  @HiveField(4)
  final double? weight; // Optional daily weight

  @HiveField(5)
  final double? waist; // Optional weekly waist measurement

  WorkoutEntry({
    this.isCompleted = false,
    required this.type,
    required this.durationMinutes,
    required this.exercises,
    this.weight,
    this.waist,
  });
}
