// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WheelAdapter extends TypeAdapter<Wheel> {
  @override
  final int typeId = 1;

  @override
  Wheel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wheel(
      id: fields[0] as int,
      content: fields[1] as String,
      color: fields[2] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Wheel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WheelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
