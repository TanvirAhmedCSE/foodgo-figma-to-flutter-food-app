import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserProfileScreen extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String email;
  final String deliveryAddress;
  final String password;

  const UserProfileScreen({
    super.key,
    required this.profilePicture,
    required this.name,
    required this.email,
    required this.deliveryAddress,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryRed,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 160),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 90),

                        _ProfileField(label: 'Name', value: name),
                        const SizedBox(height: 20),

                        _ProfileField(label: 'Email', value: email),
                        const SizedBox(height: 20),

                        _ProfileField(
                          label: 'Delivery address',
                          value: deliveryAddress,
                        ),
                        const SizedBox(height: 20),

                        _PasswordField(password: password),

                        const SizedBox(height: 35),

                        const Divider(color: Color(0xFFE0E0E0), thickness: 1),

                        const SizedBox(height: 5),

                        _MenuRow(title: 'Payment Details'),
                        const SizedBox(height: 0),

                        _MenuRow(title: 'Order history'),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              _BottomButtons(),
            ],
          ),

          _RedHeader(),

          Positioned(
            top: 105,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryRed, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.asset(
                    profilePicture,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF2E8E8),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.primaryRed,
                      ),
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

// Red Header (bg image + back/settings icons)

class _RedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/two_burgers.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),

                      child: Image.asset(
                        'assets/images/arrow-left-white.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},

                      child: Center(
                        child: Image.asset(
                          'assets/images/settings.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Field Widget

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D0D0), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 12,
            child: Container(
              color: AppTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.grayText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Password Field Widget

class _PasswordField extends StatelessWidget {
  final String password;

  const _PasswordField({required this.password});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D0D0), width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
            child: Row(
              children: List.generate(
                password.length,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: AppTheme.darkText,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 12,
            child: Container(
              color: AppTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.grayText,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.lock, size: 14, color: AppTheme.grayText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Menu Row

class _MenuRow extends StatelessWidget {
  final String title;

  const _MenuRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppTheme.grayText,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.grayText, size: 22),
          ],
        ),
      ),
    );
  }
}

// Bottom Buttons

class _BottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.darkText,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEF2A39).withOpacity(0.20),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.white,
                      ),
                    ),
                    SizedBox(width: 12),

                    Image.asset(
                      'assets/images/edit.png',
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.primaryRed, width: 1.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    SizedBox(width: 12),

                    Image.asset(
                      'assets/images/sign-out.png',
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
