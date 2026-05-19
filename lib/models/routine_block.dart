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
/// Can be customized by the user.
@HiveType(typeId: 6)
class RoutineBlock extends HiveObject {
  @HiveField(0)
  final String blockId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String startTime;

  @HiveField(3)
  final String endTime;

  RoutineBlock({
    required this.blockId,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  RoutineBlock copyWith({
    String? name,
    String? startTime,
    String? endTime,
  }) {
    return RoutineBlock(
      blockId: blockId,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
