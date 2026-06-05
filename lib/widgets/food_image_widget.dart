import 'package:flutter/material.dart';

Widget buildFoodImage({
  required String imagePath,
  double? height,
  double? width,
  double radius = 15,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[200],
          child: const Icon(Icons.restaurant, size: 50, color: Colors.grey),
        );
      },
    ),
  );
}
