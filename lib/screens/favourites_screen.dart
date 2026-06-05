import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/favourites_service.dart';
import '../models/favourite_item.dart';
import '../screens/food_detail_screen.dart';
import '../screens/food_customize_screen.dart';
import '../widgets/confirm_dialog.dart';
import '../utils/snackbar_helper.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _svc = FavouritesService.instance;

  @override
  void initState() {
    super.initState();
    _svc.addListener(_onChanged);
  }

  @override
  void dispose() {
    _svc.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _navigate(FavouriteItem item) {
    if (item.type == 'classic') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodDetailScreen(
            imagePath: item.image,
            foodName: item.name,
            description: item.description ?? '',
            rating: item.rating ?? 0.0,
            deliveryTime: item.deliveryTime ?? '',
            unitPrice: item.price ?? 0.0,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodCustomizeScreen(
            foodName: item.name,
            foodImagePath: item.image,
            basePrice: item.basePrice ?? 0.0,
            toppings: _svc.decodeToppings(item),
            sideOptions: _svc.decodeSides(item),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favourites = _svc.favourites;

    return Scaffold(
      backgroundColor: AppTheme.lightGrayBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/arrow-left.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Favourites',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkText,
                        ),
                      ),
                      Text(
                        '${favourites.length} item${favourites.length == 1 ? '' : 's'} saved',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.grayText,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/favourite.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //  List
            Expanded(
              child: favourites.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: favourites.length,
                      itemBuilder: (context, index) {
                        final item = favourites[index];
                        return _FavouriteListTile(
                          item: item,
                          onTap: () => _navigate(item),
                          onDelete: () async {
                            final confirmed = await ConfirmDialog.show(
                              context,
                              title: 'Remove Favourite',
                              message:
                                  'Are you sure you want to remove "${item.name}" from your favourites?',
                              confirmLabel: 'Yes, Remove',
                              icon: Icons.delete_outline_rounded,
                            );
                            if (confirmed == true) {
                              _svc.remove(item.id);
                              SnackbarHelper.showFavouriteSnackBar(
                                context,
                                foodName: item.name,
                                isAdded: false,
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Single list tile

class _FavouriteListTile extends StatelessWidget {
  final FavouriteItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FavouriteListTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isClassic = item.type == 'classic';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              //  Food image
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFF8F8F8),
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.restaurant,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              //  Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTheme.foodTitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      style: AppTheme.foodSubtitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (isClassic)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppTheme.orange,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating?.toString() ?? '',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryRed.withOpacity(0.30),
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
                              size: 12,
                            ),
                            SizedBox(width: 1),
                            Text(
                              'CUSTOM',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              //  Delete button
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppTheme.primaryRed,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Empty state

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: AppTheme.primaryRed.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No favourites yet',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the heart on any food\nto save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.grayText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
