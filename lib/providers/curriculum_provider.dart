import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/course_progress.dart';
import '../core/constants/curriculum.dart';
import '../core/constants/app_constants.dart';

part 'curriculum_provider.g.dart';

@riverpod
class CurriculumNotifier extends _$CurriculumNotifier {
  @override
  Map<String, CourseProgress> build() {
    final box = Hive.box<CourseProgress>(AppConstants.courseProgressBox);
    return {for (final cp in box.values) cp.courseId: cp};
  }

  CourseProgress _ensure(String courseId) {
    final existing = state[courseId];
    if (existing != null) return existing;
    final progress = CourseProgress(courseId: courseId);
    final box = Hive.box<CourseProgress>(AppConstants.courseProgressBox);
    box.add(progress);
    state = {...state, courseId: progress};
    return progress;
  }

  void toggleModule(String courseId, String moduleId) {
    final progress = _ensure(courseId);
    final updated = List<String>.from(progress.completedModuleIds);
    if (updated.contains(moduleId)) {
      updated.remove(moduleId);
    } else {
      updated.add(moduleId);
    }
    progress.completedModuleIds = updated;
    progress.lastUpdated = DateTime.now();
    progress.save();
    state = {...state, courseId: progress};
  }

  double getProgress(String courseId) {
    final course = Curriculum.courses.firstWhere((c) => c.id == courseId);
    final progress = state[courseId];
    if (progress == null || progress.completedModuleIds.isEmpty) return 0.0;
    final total = course.totalModules;
    if (total == 0) return 0.0;
    final done = progress.completedModuleIds.where((m) => course.modules.any((mod) => mod.id == m)).length;
    return done / total;
  }

  int completedCount(String courseId) {
    final progress = state[courseId];
    if (progress == null) return 0;
    final course = Curriculum.courses.firstWhere((c) => c.id == courseId);
    return progress.completedModuleIds.where((m) => course.modules.any((mod) => mod.id == m)).length;
  }

  bool isModuleCompleted(String courseId, String moduleId) {
    final progress = state[courseId];
    if (progress == null) return false;
    return progress.completedModuleIds.contains(moduleId);
  }
}

@riverpod
double overallCurriculumProgress(OverallCurriculumProgressRef ref) {
  ref.watch(curriculumNotifierProvider);
  final notifier = ref.read(curriculumNotifierProvider.notifier);
  double total = 0;
  for (final course in Curriculum.courses) {
    total += notifier.getProgress(course.id);
  }
  return Curriculum.courses.isEmpty ? 0 : total / Curriculum.courses.length;
}

@riverpod
int totalModulesCompleted(TotalModulesCompletedRef ref) {
  ref.watch(curriculumNotifierProvider);
  final notifier = ref.read(curriculumNotifierProvider.notifier);
  int total = 0;
  for (final course in Curriculum.courses) {
    total += notifier.completedCount(course.id);
  }
  return total;
}
