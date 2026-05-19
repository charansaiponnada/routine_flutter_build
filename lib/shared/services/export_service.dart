import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'hive_service.dart';

class ExportService {
  ExportService._();

  /// Compiles all Hive data into a single JSON map.
  static Map<String, dynamic> _compileData() {
    final dailyLogs = HiveService.dailyLogBox.values.map((log) => {
      'date': log.date.toIso8601String(),
      'habits': log.habits.map((h) => {'id': h.habitId, 'val': h.value}).toList(),
      'study': log.studySessions.map((s) => {'sub': s.subjectId, 'dur': s.durationMinutes}).toList(),
      'streak': log.streakCount,
      'notes': {'morning': log.morningNote, 'evening': log.eveningNote},
    }).toList();

    final mockTests = HiveService.getAllMockTests().map((t) => {
      'date': t.date.toIso8601String(),
      'score': t.score,
      'total': t.totalMarks,
      'subject': t.subject,
    }).toList();

    final routineBlocks = HiveService.getRoutineBlocks().map((b) => {
      'id': b.blockId,
      'name': b.name,
      'start': b.startTime,
      'end': b.endTime,
    }).toList();

    return {
      'export_date': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'daily_logs': dailyLogs,
      'mock_tests': mockTests,
      'routine_blocks': routineBlocks,
    };
  }

  /// Exports data to a JSON file in the application documents directory.
  /// In a real app, this would use a file picker or share sheet.
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
