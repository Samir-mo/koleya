import 'package:flutter/material.dart';
import 'package:koleya/core/router/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الجزء العلوي المنحني بالأزرق
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              width: double.infinity,
              height: size.height * 0.35,
              color: const Color(0xFF002F6C),
              alignment: Alignment.center,
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    "Gate Buddy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // المحتوى الرئيسي
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Welcome 👋",
                  style: TextStyle(
                    color: Color(0xFF002F6C),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Log in to access your account or create a new one to get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
                  ),
                ),
                const SizedBox(height: 50),

                // الأزرار: Log in / Sign up
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.welcome);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002F6C),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: Color(0xFFD39A28),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.signup);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF002F6C), width: 2),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF002F6C),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // الدائرة الذهبية السفلية اليسرى
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(color: Color(0xFFD39A28), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

// الموجة العلوية
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
