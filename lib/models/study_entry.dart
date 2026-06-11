import 'package:hive/hive.dart';

part 'study_entry.g.dart';

@HiveType(typeId: 2)
class StudyEntry extends HiveObject {
  @HiveField(0)
  final String courseId;

  @HiveField(1)
  final String topicName;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? resourcesUsed;

  @HiveField(5)
  final String? moduleId;

  StudyEntry({
    required this.courseId,
    required this.topicName,
    required this.durationMinutes,
    required this.date,
    this.resourcesUsed,
    this.moduleId,
  });
}
