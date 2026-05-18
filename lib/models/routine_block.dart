import 'package:hive/hive.dart';

part 'routine_block.g.dart';

/// Status of a routine block for a specific day.
/// Embedded within DailyLog.
@HiveType(typeId: 4)
class RoutineBlockStatus extends HiveObject {
  @HiveField(0)
  final String blockId;

  @HiveField(1)
  final String status; // 'done', 'partial', 'skipped', 'pending'

  @HiveField(2)
  final int? actualDurationMinutes; // For partial completion

  RoutineBlockStatus({
    required this.blockId,
    this.status = 'pending',
    this.actualDurationMinutes,
  });
}

/// Helper for the UI to represent the static structure of a block.
/// Not stored in Hive, but used to map status to names/times.
class RoutineBlock {
  final String blockId;
  final String name;
  final String startTime;
  final String endTime;

  RoutineBlock({
    required this.blockId,
    required this.name,
    required this.startTime,
    required this.endTime,
  });
}
