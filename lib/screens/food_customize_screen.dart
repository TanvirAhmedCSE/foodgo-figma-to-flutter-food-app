import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/spicy_slider_widget.dart';
import '../widgets/portion_counter_widget.dart';
import 'payment_screen.dart';

//  Data Models

class ToppingItem {
  final String name;
  final String imagePath;
  final double price; // added to total when selected

  const ToppingItem({
    required this.name,
    required this.imagePath,
    this.price = 0.0,
  });
}

class SideItem {
  final String name;
  final String imagePath;
  final double price;

  const SideItem({
    required this.name,
    required this.imagePath,
    this.price = 0.0,
  });
}

//  Reusable Screen

class FoodCustomizeScreen extends StatefulWidget {
  final String foodName;
  final String foodImagePath;
  final double basePrice;
  final List<ToppingItem> toppings;
  final List<SideItem> sideOptions;

  const FoodCustomizeScreen({
    super.key,
    required this.foodName,
    required this.foodImagePath,
    required this.basePrice,
    required this.toppings,
    required this.sideOptions,
  });

  @override
  State<FoodCustomizeScreen> createState() => _FoodCustomizeScreenState();
}

class _FoodCustomizeScreenState extends State<FoodCustomizeScreen>
    with SingleTickerProviderStateMixin {
  double _spicyLevel = 0.75;
  int _portion = 1;

  // index -> price  (only selected items are in the map)
  final Map<int, double> _selectedToppings = {};
  final Map<int, double> _selectedSides = {};

  // Animation for the "+X.XX" / "-X.XX" delta label
  late final AnimationController _deltaCtrl;
  late Animation<double> _deltaOpacity;

  // What to show in the delta label: e.g. "+1.50" or "-0.50"
  String _deltaText = '';

  //  Computed totals

  double get _extrasTotal =>
      _selectedToppings.values.fold(0.0, (s, p) => s + p) +
      _selectedSides.values.fold(0.0, (s, p) => s + p);

  double get _totalPrice => ((widget.basePrice + _extrasTotal) * _portion);

  void _goToPaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(orderAmount: _totalPrice),
      ),
    );
  }

  //  Lifecycle

  @override
  void initState() {
    super.initState();
    _deltaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _deltaOpacity = CurvedAnimation(
      parent: _deltaCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );
    // reverse fades it out
    _deltaCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _deltaCtrl.reverse();
      }
    });
  }

  @override
  void dispose() {
    _deltaCtrl.dispose();
    super.dispose();
  }

  //  Helpers

  void _showDelta(double delta) {
    final sign = delta >= 0 ? '+' : '-';
    setState(() {
      _deltaText = '$sign\$${delta.abs().toStringAsFixed(2)} x$_portion';
    });
    _deltaCtrl.forward(from: 0.0);
  }

  void _toggleTopping(int i) {
    final price = widget.toppings[i].price;
    if (_selectedToppings.containsKey(i)) {
      _selectedToppings.remove(i);
      if (price > 0) _showDelta(-price);
    } else {
      _selectedToppings[i] = price;
      if (price > 0) _showDelta(price);
    }
    setState(() {});
  }

  void _toggleSide(int i) {
    final price = widget.sideOptions[i].price;
    if (_selectedSides.containsKey(i)) {
      _selectedSides.remove(i);
      if (price > 0) _showDelta(-price);
    } else {
      _selectedSides[i] = price;
      if (price > 0) _showDelta(price);
    }
    setState(() {});
  }

  //  Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(),

              //  Hero + Customise panel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        widget.foodImagePath,
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 32),

                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Customize ',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'Your ${widget.foodName} to Your Tastes. Ultimate Experience',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          SpicySlider(
                            spicyLevel: _spicyLevel,
                            onChanged: (v) => setState(() => _spicyLevel = v),
                          ),

                          const SizedBox(height: 20),

                          PortionCounter(
                            portion: _portion,
                            onIncrement: () => setState(() => _portion++),
                            onDecrement: () => setState(() {
                              if (_portion > 1) _portion--;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //  Toppings
              _SectionTitle(title: 'Toppings'),
              const SizedBox(height: 12),
              _HorizontalItemList(
                items: widget.toppings
                    .map(
                      (t) => _ItemData(
                        name: t.name,
                        imagePath: t.imagePath,
                        price: t.price,
                      ),
                    )
                    .toList(),
                selected: _selectedToppings,
                onTap: _toggleTopping,
              ),

              const SizedBox(height: 24),

              //  Side options
              _SectionTitle(title: 'Side options'),
              const SizedBox(height: 12),
              _HorizontalItemList(
                items: widget.sideOptions
                    .map(
                      (s) => _ItemData(
                        name: s.name,
                        imagePath: s.imagePath,
                        price: s.price,
                      ),
                    )
                    .toList(),
                selected: _selectedSides,
                onTap: _toggleSide,
              ),

              //  Bottom bar
              _BottomBar(
                totalPrice: _totalPrice,
                deltaText: _deltaText,
                deltaOpacity: _deltaOpacity,
                onOrderNow: _goToPaymentScreen,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

//  Internal widgets

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppTheme.cardShadow,
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppTheme.cardShadow,
            ),

            child: Center(
              child: Image.asset(
                'assets/images/search.png',
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppTheme.darkText,
        ),
      ),
    );
  }
}

//  Item list

class _ItemData {
  final String name;
  final String imagePath;
  final double price;
  const _ItemData({
    required this.name,
    required this.imagePath,
    required this.price,
  });
}

class _HorizontalItemList extends StatelessWidget {
  final List<_ItemData> items;
  final Map<int, double> selected;
  final ValueChanged<int> onTap;

  const _HorizontalItemList({
    required this.items,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = items[i];
          final isSelected = selected.containsKey(i);
          return GestureDetector(
            onTap: () => onTap(i),
            child: _ItemCard(
              name: item.name,
              imagePath: item.imagePath,
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final bool isSelected;

  const _ItemCard({
    required this.name,
    required this.imagePath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 85,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // white image area
                Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                // dark label area
                SizedBox(
                  height: 34,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 24, top: 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // + / ✓ button
            Positioned(
              right: 5,
              bottom: 7,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : AppTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.add,
                  color: AppTheme.white,
                  size: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Bottom bar

class _BottomBar extends StatelessWidget {
  final double totalPrice;
  final String deltaText;
  final Animation<double> deltaOpacity;
  final VoidCallback onOrderNow;

  const _BottomBar({
    required this.totalPrice,
    required this.deltaText,
    required this.deltaOpacity,
    required this.onOrderNow,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdding = deltaText.startsWith('+');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 42, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Price block
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: AppTheme.grayText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main price (same as before)
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '\$',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.red,
                            ),
                          ),
                          TextSpan(
                            text: totalPrice.toStringAsFixed(2),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),

                    FadeTransition(
                      opacity: deltaOpacity,
                      child: Text(
                        deltaText,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isAdding
                              ? const Color(0xFF2E7D32)
                              : AppTheme.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 60),

          //  ORDER NOW
          Expanded(
            child: GestureDetector(
              onTap: onOrderNow,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppTheme.buttonShadow,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ORDER NOW',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppTheme.white,
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
