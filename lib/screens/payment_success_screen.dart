import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _fadeController;
  bool _showCheck = false;

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Separate fade controller — runs once, no flicker
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();

    // Spinning controller — continuous rotation
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    // After 2 seconds: stop spinner, show check icon + enable button
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _spinController.stop();
        setState(() => _showCheck = true);
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCard(context),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Red circle: spinner → check icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppTheme.primaryRed,
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showCheck
                  ? const Icon(
                      Icons.check,
                      key: ValueKey('check'),
                      color: AppTheme.white,
                      size: 42,
                    )
                  : Padding(
                      key: const ValueKey('spinner'),
                      padding: const EdgeInsets.all(14),
                      child: AnimatedBuilder(
                        animation: _spinController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _spinController.value * 2 * 3.14159,
                            child: child,
                          );
                        },
                        child: CustomPaint(
                          painter: _ArcSpinnerPainter(),
                          size: const Size(52, 52),
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 22),

          // Title: "Working..." → "Success !"
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _showCheck ? 'Success !' : 'Working...',
              key: ValueKey(_showCheck ? 'title_success' : 'title_working'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryRed,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle: "Wait for few seconds." → full success message
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _showCheck
                  ? 'Your payment was successful.\nA receipt for this purchase has\nbeen sent to your email.'
                  : 'Wait for few seconds.',
              key: ValueKey(_showCheck ? 'sub_success' : 'sub_waiting'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppTheme.grayText,
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Go Back button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _showCheck
                  ? () =>
                        Navigator.of(context).popUntil((route) => route.isFirst)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _showCheck
                      ? AppTheme.primaryRed
                      : const Color(0xFFB0B0B0),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _showCheck ? AppTheme.buttonShadow : [],
                ),
                child: const Center(
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Draws a white arc (290° out of 360°) with a gap — the spinner ring
class _ArcSpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const double gapDegrees = 70;
    const double startAngle = -90 * (3.14159 / 180); // start from top
    final double sweepAngle = (360 - gapDegrees) * (3.14159 / 180);

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcSpinnerPainter oldDelegate) => false;
}
