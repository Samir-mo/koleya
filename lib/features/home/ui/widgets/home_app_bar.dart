import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/features/profile/ui/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.primaryBlue});

  final Color primaryBlue;
  static const Color iconGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: primaryBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.search);
            },
            child: const Icon(Icons.search, color: iconGold, size: 28),
          ),
          const Text(
            'Gate buddy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Icon(Icons.person_outline, color: iconGold, size: 28),
          ),
        ],
      ),
    );
  }
}
