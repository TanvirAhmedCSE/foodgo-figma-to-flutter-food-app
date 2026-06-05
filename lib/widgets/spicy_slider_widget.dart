import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpicySlider extends StatelessWidget {
  final double spicyLevel;
  final ValueChanged<double> onChanged;

  const SpicySlider({
    super.key,
    required this.spicyLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Spicy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),

        const SizedBox(height: 8),

        // Slider shifted left to align with title
        Transform.translate(
          offset: const Offset(-23, 0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const ShadowedTrackShape(),
              overlayColor: AppTheme.red.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const PillThumbShape(width: 8, height: 12),
            ),
            child: Slider(
              value: spicyLevel,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          ),
        ),

        // Mild & Hot labels
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Invisible placeholder to give Stack a height
              const SizedBox(height: 20),
              // Mild label, left edge
              const Positioned(
                left: 0,
                child: Text(
                  'Mild',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Hot label, right edge
              const Positioned(
                right: 45,
                child: Text(
                  'Hot',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom pill-shaped thumb
class PillThumbShape extends SliderComponentShape {
  final double width;
  final double height;

  const PillThumbShape({this.width = 12, this.height = 16});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Shadow (must be drawn before fill)
    final shadowPaint = Paint()
      ..color = AppTheme.orange.withValues(alpha: 0.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: width + 6, height: height + 6),
      Radius.circular(5),
    );

    // Red fill
    final fillPaint = Paint()
      ..color = AppTheme.red
      ..style = PaintingStyle.fill;

    // White border
    final borderPaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: width, height: height),
      Radius.circular(3),
    );

    canvas.drawRRect(shadowRect, shadowPaint);
    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, borderPaint);
  }
}

// Custom track shape with shadow only on active part
class ShadowedTrackShape extends RoundedRectSliderTrackShape {
  const ShadowedTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final canvas = context.canvas;
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Active part (left side — up to thumb)
    final activeRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
      ),
      Radius.circular(trackHeight / 2),
    );

    // Inactive part (right side — from thumb to end)
    final inactiveRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
      ),
      Radius.circular(trackHeight / 2),
    );

    // Active shadow
    final shadowPaint = Paint()
      ..color = AppTheme.orange.withValues(alpha: 0.34)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.top - 2,
        thumbCenter.dx,
        trackRect.bottom + 2,
      ),
      Radius.circular(trackHeight / 2),
    );

    // Draw inactive track
    canvas.drawRRect(inactiveRect, Paint()..color = Colors.green[200]!);

    // Draw active shadow (before fill)
    canvas.drawRRect(shadowRect, shadowPaint);

    // Draw active track
    canvas.drawRRect(activeRect, Paint()..color = AppTheme.red);
  }
}
