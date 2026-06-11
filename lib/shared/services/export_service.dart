import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/course_progress.dart';
import '../../core/constants/app_constants.dart';
import 'hive_service.dart';

class ExportService {
  ExportService._();

  static Map<String, dynamic> _compileData() {
    final dailyLogs = HiveService.dailyLogBox.values.map((log) => {
      'date': log.date.toIso8601String(),
      'habits': log.habits.map((h) => {'id': h.habitId, 'val': h.value}).toList(),
      'study': log.studySessions.map((s) => {'course': s.courseId, 'dur': s.durationMinutes}).toList(),
      'streak': log.streakCount,
      'notes': {'morning': log.morningNote, 'evening': log.eveningNote},
    }).toList();

    final routineBlocks = HiveService.getRoutineBlocks().map((b) => {
      'id': b.blockId,
      'name': b.name,
      'start': b.startTime,
      'end': b.endTime,
    }).toList();

    final courseProgressBox = Hive.box<CourseProgress>(AppConstants.courseProgressBox);
    final courseProgress = courseProgressBox.values.map((cp) => {
      'courseId': cp.courseId,
      'completedModules': cp.completedModuleIds,
      'lastUpdated': cp.lastUpdated.toIso8601String(),
    }).toList();

    return {
      'export_date': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'daily_logs': dailyLogs,
      'routine_blocks': routineBlocks,
      'course_progress': courseProgress,
    };
  }

  static Future<String?> exportAsJson() async {
    try {
      final data = _compileData();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/forge_routine_backup_${DateTime.now().millisecondsSinceEpoch}.json');

      await file.writeAsString(jsonStr);
      return file.path;
    } catch (e) {
      return null;
    }
  }
}
