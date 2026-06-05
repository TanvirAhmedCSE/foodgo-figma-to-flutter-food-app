import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double orderAmount;
  final String deliveryTime;

  const PaymentScreen({
    super.key,
    required this.orderAmount,
    this.deliveryTime = "Based on Portions", // default value
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // 0 = MasterCard (Credit), 1 = Visa (Debit)
  int _selectedPayment = 0;
  bool _saveCardDetails = true;

  static const double _taxes = 0.3;
  static const double _deliveryFees = 1.5;

  double get _total => widget.orderAmount + _taxes + _deliveryFees;

  void _onPayNow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 20),
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

                                child: Align(
                                  alignment: Alignment
                                      .centerLeft, // more left: alignment: Alignment(-1.2, 0),
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

                      // Order Summary Title
                      const Text(
                        'Order summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Order Row
                      _buildSummaryRow(
                        label: 'Order',
                        value: '\$${widget.orderAmount.toStringAsFixed(2)}',
                        isLight: true,
                      ),
                      const SizedBox(height: 12),

                      // Taxes Row
                      _buildSummaryRow(
                        label: 'Taxes',
                        value: '\$${_taxes.toStringAsFixed(1)}',
                        isLight: true,
                      ),
                      const SizedBox(height: 12),

                      // Delivery Fees Row
                      _buildSummaryRow(
                        label: 'Delivery fees',
                        value: '\$${_deliveryFees.toStringAsFixed(1)}',
                        isLight: true,
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Divider(color: Colors.grey[200], thickness: 1),

                      const SizedBox(height: 14),

                      // Total Row
                      _buildSummaryRow(
                        label: 'Total:',
                        value: '\$${_total.toStringAsFixed(2)}',
                        isLight: false,
                        isBold: true,
                      ),

                      const SizedBox(height: 12),

                      // Estimated Delivery Time Row
                      _buildSummaryRow(
                        label: 'Estimated delivery time:',
                        value: widget.deliveryTime,
                        isLight: false,
                        isBold: true,
                      ),

                      const SizedBox(height: 36),

                      // Payment Methods Title
                      const Text(
                        'Payment methods',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // MasterCard Option
                      _buildPaymentOption(
                        index: 0,
                        logo: _buildMasterCardLogo(),
                        title: 'Credit card',
                        subtitle: '5105 **** **** 0505',
                      ),

                      const SizedBox(height: 12),

                      // Visa Option
                      _buildPaymentOption(
                        index: 1,
                        logo: _buildVisaLogo(),
                        title: 'Debit card',
                        subtitle: '3566 **** **** 0505',
                      ),

                      const SizedBox(height: 20),

                      // Save Card Details Checkbox
                      GestureDetector(
                        onTap: () {
                          setState(() => _saveCardDetails = !_saveCardDetails);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: _saveCardDetails
                                    ? AppTheme.primaryRed
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _saveCardDetails
                                      ? AppTheme.primaryRed
                                      : Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              child: _saveCardDetails
                                  ? const Icon(
                                      Icons.check,
                                      color: AppTheme.white,
                                      size: 10,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Save card details for future payments',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.grayText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppTheme.white,
              child: Row(
                children: [
                  // Total Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total price',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.grayText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '\$',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                          Text(
                            _total.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              //color: AppTheme.darkText,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: 24),

                  // Pay Now Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _onPayNow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.darkText,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.buttonShadow,
                        ),
                        child: const Center(
                          child: Text(
                            'Pay Now',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required bool isLight,
    bool isBold = false,
  }) {
    final color = isLight ? AppTheme.grayText : AppTheme.darkText;
    final weight = isBold ? FontWeight.bold : FontWeight.w400;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color, fontWeight: weight),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: color, fontWeight: weight),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required Widget logo,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _selectedPayment == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkText : AppTheme.lightGrayBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Logo
            SizedBox(width: 60, child: logo),
            const SizedBox(width: 14),

            // Card Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.white : AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white60 : AppTheme.grayText,
                    ),
                  ),
                ],
              ),
            ),

            // Radio
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.white : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // MasterCard logo from assets
  Widget _buildMasterCardLogo() {
    return Image.asset(
      'assets/images/mastercard.png',
      width: 50,
      height: 32,
      fit: BoxFit.contain,
    );
  }

  // Visa logo from assets
  Widget _buildVisaLogo() {
    return Image.asset(
      'assets/images/visacard.png',
      width: 50,
      height: 32,
      fit: BoxFit.contain,
    );
  }
}
