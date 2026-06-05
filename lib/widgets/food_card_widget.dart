import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/snackbar_helper.dart';
import '../services/favourites_service.dart';
import 'confirm_dialog.dart';

class FoodCardWidget extends StatefulWidget {
  final String imagePath;
  final String foodName;
  final String subtitle;
  final double rating;
  final VoidCallback onTap;
  final Map<String, dynamic> foodData;

  const FoodCardWidget({
    super.key,
    required this.imagePath,
    required this.foodName,
    required this.subtitle,
    required this.rating,
    required this.onTap,
    required this.foodData,
  });

  @override
  State<FoodCardWidget> createState() => _FoodCardWidgetState();
}

class _FoodCardWidgetState extends State<FoodCardWidget> {
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
    final foodId = FavouritesService.buildId(widget.foodName, 'classic');
    final isFav = _svc.isFavourite(foodId);

    return GestureDetector(
      onTap: widget.onTap,
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
              //  Food Image
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

              //  Rating + Heart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(widget.rating.toString(), style: AppTheme.ratingStyle),
                    const Spacer(),
                    GestureDetector(
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
                          _svc.addClassic(widget.foodData);
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
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
