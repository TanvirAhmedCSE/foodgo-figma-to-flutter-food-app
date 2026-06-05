import 'package:hive/hive.dart';

part 'favourite_item.g.dart';

@HiveType(typeId: 0)
class FavouriteItem extends HiveObject {
  @HiveField(0)
  final String id; // unique identifier (foodName + type)

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String subtitle;

  @HiveField(4)
  final String image;

  //  Classic only
  @HiveField(5)
  final double? rating;

  @HiveField(6)
  final double? price;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final String? deliveryTime;

  //  Customized only
  @HiveField(9)
  final double? basePrice;

  @HiveField(10)
  final String? toppingsJson;

  @HiveField(11)
  final String? sideOptionsJson;

  FavouriteItem({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.image,
    this.rating,
    this.price,
    this.description,
    this.deliveryTime,
    this.basePrice,
    this.toppingsJson,
    this.sideOptionsJson,
  });
}
