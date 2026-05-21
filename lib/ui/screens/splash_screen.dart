import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/data/storage/auth_storage.dart';
import 'package:gate_buddy/data/storage/storage_helper.dart';

import '../../features/auth/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // ⏳ بعد الأنيميشن نتحقق من الحالة بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;

    // 🔹 أولًا: هل المستخدم شاف الـ Onboarding؟
    final seen = StorageHelper.get("onboarding_seen") ?? false;

    if (!seen) {
      Navigator.pushNamed(context, Routes.mainScaffold);
      return;
    }

    // 🔹 ثانيًا: هل عنده توكن؟
    final token = AuthStorage.getToken();

    if (token != null && token.isNotEmpty) {
      // ✅ المستخدم مسجل دخول سابقًا
      context.pushNamedAndRemoveAll(Routes.mainScaffold);
    } else {
      // 🚪 المستخدم جديد أو سجل خروج → نروّح على Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002F6C),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Splash.png", // 🔶 تأكد الاسم والمسار
                  width: 130,
                  height: 130,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Gate Buddy",
                  style: TextStyle(
                    color: Color(0xFFD39A28),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(
                  color: Color(0xFFD39A28),
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
