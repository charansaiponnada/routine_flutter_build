import 'package:hive/hive.dart';

part 'course_progress.g.dart';

@HiveType(typeId: 7)
class CourseProgress extends HiveObject {
  @HiveField(0)
  String courseId;

  @HiveField(1)
  List<String> completedModuleIds;

  @HiveField(2)
  DateTime lastUpdated;

  CourseProgress({
    required this.courseId,
    this.completedModuleIds = const [],
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}
