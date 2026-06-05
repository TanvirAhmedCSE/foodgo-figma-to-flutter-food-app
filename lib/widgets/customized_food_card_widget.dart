import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/food_customize_screen.dart';
import '../utils/snackbar_helper.dart';
import '../services/favourites_service.dart';
import 'confirm_dialog.dart';

class CustomizedFoodCardWidget extends StatefulWidget {
  final String imagePath;
  final String foodName;
  final String subtitle;
  final double basePrice;
  final List<ToppingItem>? toppings;
  final List<SideItem>? sideOptions;
  final Map<String, dynamic> foodData;

  const CustomizedFoodCardWidget({
    super.key,
    required this.imagePath,
    required this.foodName,
    required this.subtitle,
    required this.basePrice,
    this.toppings,
    this.sideOptions,
    required this.foodData,
  });

  @override
  State<CustomizedFoodCardWidget> createState() =>
      _CustomizedFoodCardWidgetState();
}

class _CustomizedFoodCardWidgetState extends State<CustomizedFoodCardWidget> {
  final _svc = FavouritesService.instance;

  @override
  void initState() {
    super.initState();
    _svc.addListener(_onFavChanged);
  }

  @override
  void dispose() {
    _svc.removeListener(_onFavChanged);
    super.dispose();
  }

  void _onFavChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final foodId = FavouritesService.buildId(widget.foodName, 'customized');
    final isFav = _svc.isFavourite(foodId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodCustomizeScreen(
              foodName: widget.foodName,
              foodImagePath: widget.imagePath,
              basePrice: widget.basePrice,
              toppings: widget.toppings!,
              sideOptions: widget.sideOptions!,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: const Color(0xFFF8F8F8),
                  child: Image.asset(
                    widget.imagePath,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              //  Food Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.foodName,
                  style: AppTheme.foodTitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 2),

              //  Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.subtitle,
                  style: AppTheme.foodSubtitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              //  CUSTOM Badge + Heart
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryRed.withOpacity(0.35),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.amber,
                            size: 13,
                          ),
                          SizedBox(width: 1),
                          Text(
                            'CUSTOM',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () async {
                        if (isFav) {
                          final confirmed = await ConfirmDialog.show(
                            context,
                            title: 'Remove Favourite',
                            message:
                                'Remove "${widget.foodName}" from your favourites?',
                            confirmLabel: 'Yes, Remove',
                            icon: Icons.favorite_rounded,
                          );
                          if (confirmed == true) {
                            _svc.remove(foodId);
                            SnackbarHelper.showFavouriteSnackBar(
                              context,
                              foodName: widget.foodName,
                              isAdded: false,
                            );
                          }
                        } else {
                          _svc.addCustomized(widget.foodData);
                          SnackbarHelper.showFavouriteSnackBar(
                            context,
                            foodName: widget.foodName,
                            isAdded: true,
                          );
                        }
                      },
                      child: isFav
                          ? Image.asset(
                              'assets/images/favourite.png',
                              width: 23.5,
                              height: 23.5,
                            )
                          : Image.asset(
                              'assets/images/not_favourite.png',
                              width: 23,
                              height: 23,
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
