import 'package:flutter/material.dart';
import '../widgets/food_image_widget.dart';
import '../widgets/spicy_slider_widget.dart';
import '../widgets/portion_counter_widget.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

// Reusable FoodDetailScreen
class FoodDetailScreen extends StatefulWidget {
  final String imagePath;
  final String foodName;
  final String description;
  final double rating;
  final String
  deliveryTime; // Estimated total delivery time (preparing food + delivery)
  final double unitPrice;

  const FoodDetailScreen({
    super.key,
    required this.imagePath,
    required this.foodName,
    required this.description,
    required this.rating,
    required this.deliveryTime,
    required this.unitPrice,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int portion = 1;
  double spicyLevel = 0.7;

  double get _orderAmount => portion * widget.unitPrice;

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          orderAmount: _orderAmount,
          deliveryTime: widget.deliveryTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Center(
                                child: Image.asset(
                                  'assets/images/arrow-left.png',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Center(
                              child: Image.asset(
                                'assets/images/search.png',
                                width: 19,
                                height: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Food Image
                    Center(
                      child: buildFoodImage(
                        imagePath: widget.imagePath,
                        height: 290,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Name
                          Text(
                            widget.foodName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Rating & Delivery Time
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppTheme.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.rating}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.grayText,
                                ),
                              ),
                              Text(
                                '  —  ${widget.deliveryTime}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.grayText,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Description
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Spicy & Portion Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Spicy Slider
                              Expanded(
                                child: SpicySlider(
                                  spicyLevel: spicyLevel,
                                  onChanged: (value) {
                                    setState(() => spicyLevel = value);
                                  },
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Portion Counter
                              PortionCounter(
                                portion: portion,
                                onIncrement: () => setState(() => portion++),
                                onDecrement: () {
                                  // Minimum portion = 1
                                  if (portion > 1) setState(() => portion--);
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.white,
              child: Row(
                children: [
                  // Price (portion * unitPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.buttonShadow,
                    ),
                    child: Text(
                      '\$${_orderAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Order Now Button → navigates to PaymentScreen
                  Expanded(
                    child: GestureDetector(
                      onTap: _goToPayment,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppTheme.darkText.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppTheme.buttonShadow,
                        ),
                        child: const Center(
                          child: Text(
                            'ORDER NOW',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
