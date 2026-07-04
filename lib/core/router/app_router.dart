import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';
import '../../features/auth/ui/forget_password_screen.dart';
import '../../features/auth/ui/get_code_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/reset_password_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
import '../../features/boarding_pass_scan/logic/cubit/boarding_pass_scan_cubit.dart';
import '../../features/boarding_pass_scan/ui/boarding_pass_scanner_screen.dart';
import '../../features/explore_places/ui/place_details_screens.dart';
import '../../features/flights/data/models/flight_model.dart';
import '../../features/indoor_map/ui/indoor_map_screen.dart';
import '../../features/main_navigation/ui/main_scaffold.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../../features/on_boarding/ui/onboarding_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/search/ui/search_screen.dart';
import '../../features/services_category/logic/cubit/services_category_cubit.dart';
import '../../features/services_category/ui/services_category_screen.dart';
import '../../features/tracked_flight/ui/tracked_flight_screen.dart';
import '../../features/tracked_flight/ui/tracked_flights_list_screen.dart';
import '../../features/flight_updates/ui/screens/flight_updates_list_screen.dart';
import '../../features/flight_updates/ui/screens/flight_detail_screen.dart';

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
        return _buildRoute(
          MainScaffold(key: MainScaffold.scaffoldKey),
          settings,
        );

      case Routes.profile:
        return _buildRoute(const ProfileScreen(), settings);

      case Routes.notifications:
        return _buildRoute(const NotificationsScreen(), settings);

      case Routes.search:
        return _buildRoute(const SearchScreen(), settings);

      case Routes.trackedFlight:
        return _buildRoute(
          TrackedFlightScreen(flight: args?['flight'] as FlightModel?),
          settings,
        );

      case Routes.trackedFlightsList:
        return _buildRoute(const TrackedFlightsListScreen(), settings);

      case Routes.placeDetailsScreen:
        return _buildRoute(PlaceDetailsScreen(place: args?['place']), settings);

      case Routes.indoorMap:
        return _buildRoute(const IndoorMapScreen(), settings);

      case Routes.servicesCategory:
        final category = args?['category'] as String? ?? 'RESTAURANTS';
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ServicesCategoryCubit>()..load(category),
            child: ServicesCategoryScreen(category: category),
          ),
          settings,
        );

      case Routes.boardingPassScan:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<BoardingPassScanCubit>(),
            child: const BoardingPassScannerScreen(),
          ),
          settings,
        );

      case Routes.flightUpdates:
        return _buildRoute(
          const FlightUpdatesListScreen(),
          settings,
        );

      case Routes.flightDetail:
        return _buildRoute(
          FlightDetailScreen(
            flightId: args?['id'] as String? ?? '',
            flight: args?['flight'] as FlightModel?,
          ),
          settings,
        );

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
