// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutEntryAdapter extends TypeAdapter<WorkoutEntry> {
  @override
  final int typeId = 3;

  @override
  WorkoutEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutEntry(
      isCompleted: fields[0] as bool,
      type: fields[1] as String,
      durationMinutes: fields[2] as int,
      exercises: (fields[3] as List).cast<String>(),
      weight: fields[4] as double?,
      waist: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isCompleted)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.waist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
