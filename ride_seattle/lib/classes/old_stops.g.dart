// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'old_stops.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OldStopsAdapter extends TypeAdapter<OldStops> {
  @override
  final int typeId = 1;

  @override
  OldStops read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OldStops(
      stopId: fields[0] as String,
      name: fields[1] as String,
      lat: fields[2] as double,
      lon: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OldStops obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stopId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OldStopsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
