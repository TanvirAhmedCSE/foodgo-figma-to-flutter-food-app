import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PortionCounter extends StatelessWidget {
  final int portion;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PortionCounter({
    super.key,
    required this.portion,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Portion',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            // Minus button
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.iconButtonShadow,
                ),
                child: const Icon(
                  Icons.remove,
                  color: AppTheme.white,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Portion number
            Text(
              '$portion',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(width: 12),

            // Plus button
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.iconButtonShadow,
                ),
                child: const Icon(Icons.add, color: AppTheme.white, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
