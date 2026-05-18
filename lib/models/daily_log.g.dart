// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyLogAdapter extends TypeAdapter<DailyLog> {
  @override
  final int typeId = 0;

  @override
  DailyLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLog(
      date: fields[0] as DateTime,
      habits: (fields[1] as List).cast<HabitEntry>(),
      studySessions: (fields[2] as List).cast<StudyEntry>(),
      workout: fields[3] as WorkoutEntry?,
      routineStatuses: (fields[4] as List).cast<RoutineBlockStatus>(),
      allHabitsCompleted: fields[5] as bool,
      streakCount: fields[6] as int,
      morningNote: fields[7] as String?,
      eveningNote: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.habits)
      ..writeByte(2)
      ..write(obj.studySessions)
      ..writeByte(3)
      ..write(obj.workout)
      ..writeByte(4)
      ..write(obj.routineStatuses)
      ..writeByte(5)
      ..write(obj.allHabitsCompleted)
      ..writeByte(6)
      ..write(obj.streakCount)
      ..writeByte(7)
      ..write(obj.morningNote)
      ..writeByte(8)
      ..write(obj.eveningNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
