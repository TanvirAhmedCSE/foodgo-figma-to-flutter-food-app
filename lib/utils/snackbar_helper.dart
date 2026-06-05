import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showFavouriteSnackBar(
    BuildContext context, {
    required String foodName,
    required bool isAdded,
  }) {
    final message = isAdded
        ? "$foodName added to Favourites"
        : "$foodName removed from Favourites";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
