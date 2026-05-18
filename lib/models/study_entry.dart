import 'package:hive/hive.dart';

part 'study_entry.g.dart';

/// A study session log for a specific GATE subject.
/// Embedded within DailyLog.
@HiveType(typeId: 2)
class StudyEntry extends HiveObject {
  @HiveField(0)
  final String subjectId;

  @HiveField(1)
  final String topicName;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? resourcesUsed;

  StudyEntry({
    required this.subjectId,
    required this.topicName,
    required this.durationMinutes,
    required this.date,
    this.resourcesUsed,
  });
}
