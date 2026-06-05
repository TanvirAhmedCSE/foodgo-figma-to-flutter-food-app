import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/favourite_item.dart';
import '../screens/food_customize_screen.dart';
import 'package:flutter/foundation.dart';

class FavouritesService {
  static const String _boxName = 'favourites';

  // Singleton
  static final FavouritesService instance = FavouritesService._();
  FavouritesService._();

  late Box<FavouriteItem> _box;
  List<FavouriteItem> favourites = [];

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    for (final l in _listeners) l();
  }

  void init() {
    _box = Hive.box<FavouriteItem>(_boxName);
    favourites = _box.values.toList();
  }

  bool isFavourite(String foodId) => favourites.any((f) => f.id == foodId);

  static String buildId(String name, String type) => '${type}_$name';

  void addClassic(Map<String, dynamic> food) {
    final id = buildId(food['name'], 'classic');
    if (isFavourite(id)) return;

    final item = FavouriteItem(
      id: id,
      type: 'classic',
      name: food['name'],
      subtitle: food['subtitle'],
      image: food['image'],
      rating: (food['rating'] as num).toDouble(),
      price: (food['price'] as num).toDouble(),
      description: food['description'],
      deliveryTime: food['deliveryTime'],
    );
    _box.put(id, item);
    favourites.add(item);
    _notify();
  }

  //  Add customized

  void addCustomized(Map<String, dynamic> food) {
    final id = buildId(food['name'], 'customized');
    if (isFavourite(id)) return;

    final toppings = food['toppings'] as List<ToppingItem>?;
    final sides = food['sideOptions'] as List<SideItem>?;

    final item = FavouriteItem(
      id: id,
      type: 'customized',
      name: food['name'],
      subtitle: food['subtitle'],
      image: food['image'],
      basePrice: (food['basePrice'] as num).toDouble(),
      toppingsJson: toppings != null
          ? jsonEncode(
              toppings
                  .map(
                    (t) => {
                      'name': t.name,
                      'imagePath': t.imagePath,
                      'price': t.price,
                    },
                  )
                  .toList(),
            )
          : null,
      sideOptionsJson: sides != null
          ? jsonEncode(
              sides
                  .map(
                    (s) => {
                      'name': s.name,
                      'imagePath': s.imagePath,
                      'price': s.price,
                    },
                  )
                  .toList(),
            )
          : null,
    );
    _box.put(id, item);
    favourites.add(item);
    _notify();
  }

  //  Remove

  void remove(String foodId) {
    _box.delete(foodId);
    favourites.removeWhere((f) => f.id == foodId);
    _notify();
  }

  //  Decode helpers

  List<ToppingItem> decodeToppings(FavouriteItem item) {
    if (item.toppingsJson == null) return [];
    final list = jsonDecode(item.toppingsJson!) as List;
    return list
        .map(
          (e) => ToppingItem(
            name: e['name'],
            imagePath: e['imagePath'],
            price: (e['price'] as num).toDouble(),
          ),
        )
        .toList();
  }

  List<SideItem> decodeSides(FavouriteItem item) {
    if (item.sideOptionsJson == null) return [];
    final list = jsonDecode(item.sideOptionsJson!) as List;
    return list
        .map(
          (e) => SideItem(
            name: e['name'],
            imagePath: e['imagePath'],
            price: (e['price'] as num).toDouble(),
          ),
        )
        .toList();
  }
}
