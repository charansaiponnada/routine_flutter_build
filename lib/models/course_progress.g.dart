// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseProgressAdapter extends TypeAdapter<CourseProgress> {
  @override
  final int typeId = 7;

  @override
  CourseProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseProgress(
      courseId: fields[0] as String,
      completedModuleIds: (fields[1] as List).cast<String>(),
      lastUpdated: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CourseProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.completedModuleIds)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
