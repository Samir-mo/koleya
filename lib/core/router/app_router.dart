// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:koleya/core/router/routes.dart';
import 'package:koleya/features/indoor_map/ui/indoor_map_screen.dart';
import 'package:koleya/features/main_navigation/ui/main_scaffold.dart';
import 'package:koleya/ui/screens/get_code_screen.dart';
import 'package:koleya/ui/screens/splash_screen.dart';
import 'package:koleya/ui/screens/tracked_flight_screen.dart';

import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
// ... other imports

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);

      case Routes.login:
        return _buildRoute(LoginScreen(), settings);

      case Routes.signup:
        return _buildRoute(const SignupScreen(), settings);

      case Routes.mainScaffold:
        return _buildRoute(const MainScaffold(), settings);

      case Routes.getCode:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(GetCodeScreen(email: args?['email'] ?? ''), settings);

      case Routes.trackedFlight:
        // You can pass arguments here if needed
        return _buildRoute(
          const TrackedFlightScreen(flightNo: '', airline: '', status: ''),
          settings,
        );

      case Routes.indoorMap:
        return _buildRoute(const IndoorMapScreen(), settings);

      // Add other cases following the same pattern...

      default:
        return _buildRoute(
          Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
