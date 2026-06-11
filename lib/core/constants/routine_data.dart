import '../../models/routine_block.dart';

/// Hardcoded default routine blocks for CSP's 4 AM discipline system.
class RoutineData {
  RoutineData._();

  static List<RoutineBlock> get defaultBlocks => [
    RoutineBlock(
      blockId: 'wake_walk',
      name: 'Wake + Walk / Meditation',
      startTime: '04:00',
      endTime: '04:30',
    ),
    RoutineBlock(
      blockId: 'study_1',
      name: 'Deep Study Block 1',
      startTime: '04:30',
      endTime: '06:30',
    ),
    RoutineBlock(
      blockId: 'workout',
      name: 'Home Workout',
      startTime: '06:30',
      endTime: '07:30',
    ),
    RoutineBlock(
      blockId: 'college',
      name: 'College / Internship',
      startTime: '08:00',
      endTime: '17:30',
    ),
    RoutineBlock(
      blockId: 'study_2',
      name: 'Study Block 2 + Coding',
      startTime: '17:30',
      endTime: '19:30',
    ),
    RoutineBlock(
      blockId: 'dinner',
      name: 'Dinner + Walk',
      startTime: '19:30',
      endTime: '20:00',
    ),
    RoutineBlock(
      blockId: 'revision',
      name: 'Revision + Journal',
      startTime: '20:00',
      endTime: '21:00',
    ),
    RoutineBlock(
      blockId: 'sleep',
      name: 'Sleep target',
      startTime: '21:30',
      endTime: '04:00',
    ),
  ];
}
