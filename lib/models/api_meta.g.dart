// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiMetaAdapter extends TypeAdapter<ApiMeta> {
  @override
  final int typeId = 0;

  @override
  ApiMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiMeta(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApiMeta obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
