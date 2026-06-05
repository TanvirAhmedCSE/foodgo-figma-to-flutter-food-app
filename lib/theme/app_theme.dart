import 'package:flutter/material.dart';

class AppTheme {
  // Colors from Figma design
  static const Color primaryRed = Color(0xFFEF2939);
  static const Color darkText = Color(0xFF3C2F2F);
  static const Color grayText = Color(0xFF808080);
  static const Color lightGrayBg = Color(0xFFF2F4F7);
  static const Color white = Colors.white;
  static const Color orange = Color(0xFFFFA800);
  static const Color green = Colors.green;
  static const Color red = Color(0xFFEF2939);
  static const Color brown = Color(0xFF3C2F2F);

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      offset: const Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  static List<BoxShadow> searchShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      offset: const Offset(0, 4),
      blurRadius: 20,
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 5),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> messageBubbleShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.26),
      offset: Offset(0, 5),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> iconButtonShadow = [
    BoxShadow(
      color: Colors.orange.withOpacity(0.3),
      offset: const Offset(0, 6),
      blurRadius: 6,
    ),
  ];

  // Text Styles
  static TextStyle logoStyle = const TextStyle(
    fontFamily: 'Lobster',
    fontSize: 42,
    fontWeight: FontWeight.w400,
    color: darkText,
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: grayText,
  );

  static TextStyle foodTitleStyle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: darkText,
  );

  static TextStyle foodSubtitleStyle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: grayText,
  );

  static TextStyle bodyStyle = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: grayText,
  );

  static TextStyle buttonStyle = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: white,
  );

  static TextStyle ratingStyle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkText,
  );
}
