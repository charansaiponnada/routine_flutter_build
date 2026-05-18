// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockTestAdapter extends TypeAdapter<MockTest> {
  @override
  final int typeId = 5;

  @override
  MockTest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MockTest(
      date: fields[0] as DateTime,
      score: fields[1] as double,
      totalMarks: fields[2] as double,
      subject: fields[3] as String,
      percentileEstimate: fields[4] as double?,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MockTest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.totalMarks)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.percentileEstimate)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockTestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
