import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : AppTheme.lightGrayBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? AppTheme.buttonShadow : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: isSelected ? AppTheme.white : AppTheme.grayText,
          ),
        ),
      ),
    );
  }
}
