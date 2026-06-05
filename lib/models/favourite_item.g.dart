// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteItemAdapter extends TypeAdapter<FavouriteItem> {
  @override
  final int typeId = 0;

  @override
  FavouriteItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteItem(
      id: fields[0] as String,
      type: fields[1] as String,
      name: fields[2] as String,
      subtitle: fields[3] as String,
      image: fields[4] as String,
      rating: fields[5] as double?,
      price: fields[6] as double?,
      description: fields[7] as String?,
      deliveryTime: fields[8] as String?,
      basePrice: fields[9] as double?,
      toppingsJson: fields[10] as String?,
      sideOptionsJson: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.subtitle)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.deliveryTime)
      ..writeByte(9)
      ..write(obj.basePrice)
      ..writeByte(10)
      ..write(obj.toppingsJson)
      ..writeByte(11)
      ..write(obj.sideOptionsJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
