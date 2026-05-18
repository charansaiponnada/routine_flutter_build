// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_block.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineBlockStatusAdapter extends TypeAdapter<RoutineBlockStatus> {
  @override
  final int typeId = 4;

  @override
  RoutineBlockStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineBlockStatus(
      blockId: fields[0] as String,
      status: fields[1] as String,
      actualDurationMinutes: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineBlockStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.blockId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.actualDurationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineBlockStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
