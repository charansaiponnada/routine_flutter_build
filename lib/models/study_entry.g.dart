// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyEntryAdapter extends TypeAdapter<StudyEntry> {
  @override
  final int typeId = 2;

  @override
  StudyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyEntry(
      subjectId: fields[0] as String,
      topicName: fields[1] as String,
      durationMinutes: fields[2] as int,
      date: fields[3] as DateTime,
      resourcesUsed: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudyEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.topicName)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.resourcesUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
