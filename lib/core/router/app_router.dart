import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/features/auth/ui/forget_password_screen.dart';
import 'package:gate_buddy/features/auth/ui/login_screen.dart';
import 'package:gate_buddy/features/auth/ui/reset_password_screen.dart';
import 'package:gate_buddy/features/auth/ui/signup_screen.dart';
import 'package:gate_buddy/features/explore_places/ui/place_details_screens.dart';
import 'package:gate_buddy/features/indoor_map/ui/indoor_map_screen.dart';
import 'package:gate_buddy/features/main_navigation/ui/main_scaffold.dart';
import 'package:gate_buddy/features/notifications/ui/notifications_screen.dart';
import 'package:gate_buddy/features/on_boarding/ui/onboarding_screen.dart';
import 'package:gate_buddy/features/profile/ui/profile_screen.dart';
import 'package:gate_buddy/features/profile/ui/settings_screen.dart';
import 'package:gate_buddy/features/search/ui/search_screen.dart';
import 'package:gate_buddy/features/services/ui/accessibility_screen.dart';
import 'package:gate_buddy/features/services/ui/financial_services_screen.dart';
import 'package:gate_buddy/features/services/ui/flight_counters_screen.dart';
import 'package:gate_buddy/features/services/ui/service_details_screen.dart';
import 'package:gate_buddy/features/services/ui/services_screen.dart';
import 'package:gate_buddy/features/services/ui/vip_experience_screen.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';
import 'package:gate_buddy/features/auth/ui/get_code_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.onboarding:
        return _buildRoute(const OnboardingScreen(), settings);

      case Routes.login:
        return _buildRoute(LoginScreen(), settings);

      case Routes.signup:
        return _buildRoute(const SignupScreen(), settings);

      case Routes.forgetPassword:
        return _buildRoute(const ForgetPasswordScreen(), settings);

      case Routes.resetPassword:
        return _buildRoute(
          ResetPasswordScreen(resetToken: args?['resetToken'] as String? ?? ''),
          settings,
        );

      case Routes.getCode:
        return _buildRoute(
          GetCodeScreen(email: args?['email'] ?? ''),
          settings,
        );

      case Routes.mainScaffold:
        return _buildRoute(const MainScaffold(), settings);

      case Routes.profile:
        return _buildRoute(const ProfileScreen(), settings);

      case Routes.settings:
        return _buildRoute(const SettingsScreen(), settings);

      case Routes.notifications:
        return _buildRoute(const NotificationsScreen(), settings);

      case Routes.search:
        return _buildRoute(const SearchScreen(), settings);

      case Routes.services:
        return _buildRoute(const ServicesScreen(), settings);

      case Routes.serviceDetails:
        return _buildRoute(const ServiceDetailsScreen(), settings);

      case Routes.vipExperience:
        return _buildRoute(const VipExperienceScreen(), settings);

      case Routes.accessibility:
        return _buildRoute(const AccessibilityScreen(), settings);

      case Routes.financial:
        return _buildRoute(const FinancialServicesScreen(), settings);

      case Routes.counters:
        return _buildRoute(const FlightCountersScreen(), settings);

      case Routes.trackedFlight:
        return _buildRoute(
          TrackedFlightScreen(
            flightNo: args?['flightNo'] ?? '',
            airline: args?['airline'] ?? '',
            status: args?['status'] ?? '',
            gate: args?['gate'] ?? '',
            time: args?['time'] ?? '',
            date: args?['date'] ?? '',
            from: args?['from'] ?? '',
            to: args?['to'] ?? '',
            terminal: args?['terminal'] ?? '',
          ),
          settings,
        );

      case Routes.placeDetailsScreen:
        return _buildRoute(PlaceDetailsScreen(place: args?['place']), settings);

      case Routes.indoorMap:
        return _buildRoute(const IndoorMapScreen(), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
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
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
