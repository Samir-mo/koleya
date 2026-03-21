import 'package:flutter/material.dart';

// ✅ كل الشاشات الأساسية
import '../ui/screens/splash_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/welcome_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/signup_screen.dart';
import '../ui/screens/get_code_screen.dart';
import '../ui/screens/forget_password_screen.dart';
import '../ui/screens/reset_password_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/flights_screen.dart';
import '../ui/screens/assistant_screen.dart';
import '../ui/screens/services_screen.dart';
import '../ui/screens/tracked_flight_screen.dart';

// ✅ الشاشات الخاصة بالخدمات
import '../ui/screens/vip_experience_screen.dart';
import '../ui/screens/accessibility_screen.dart';
import '../ui/screens/financial_services_screen.dart';
import '../ui/screens/flight_counters_screen.dart';
import '../ui/screens/explore_shops_screen.dart';

// ✅ شاشة البحث
import '../ui/screens/search_screen.dart';

// ✅ شاشة الخرائط (مؤقت Placeholder)
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "🗺️ خريطة قادمة قريبًا",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Routes {
  // Auth & Start
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';

  // Forget Password Flow
  static const String forgetPassword = '/forgetPassword';
  static const String getCode = '/getCode';
  static const String resetPassword = '/resetPassword';

  // Main App
  static const String home = '/home';
  static const String profile = '/profile';
  static const String flights = '/flights';
  static const String assistant = '/assistant';
  static const String services = '/services';
  static const String trackedFlight = '/trackedFlight';

  // Services
  static const String vipExperience = '/vipExperience';
  static const String accessibility = '/accessibility';
  static const String financial = '/financialServices';
  static const String counters = '/flightCounters';
  static const String exploreShops = '/exploreShops';
  static const String serviceDetails = '/serviceDetails';

  // Search
  static const String search = '/search';

  // ✅ Map screen route (أُضيف لحل الخطأ)
  static const String mapScreen = '/map';

  /// مولّد المسارات
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ===== AUTH & START =====
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) =>  SignupScreen());

      // ===== FORGET PASSWORD FLOW =====
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case getCode:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => GetCodeScreen(email: args?['email'] ?? ''),
        );
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());

      // ===== MAIN APP SCREENS =====
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case flights:
        return MaterialPageRoute(builder: (_) => const FlightsScreen());
      case assistant:
        return MaterialPageRoute(builder: (_) => const AssistantScreen());
      case services:
        return MaterialPageRoute(builder: (_) => const ServicesScreen());
      case trackedFlight:
        return MaterialPageRoute(
          builder: (_) => const TrackedFlightScreen(
            flightNo: '',
            airline: '',
            status: '',
          ),
        );

      // ===== SERVICES SECTION =====
      case vipExperience:
        return MaterialPageRoute(builder: (_) => const VipExperienceScreen());
      case accessibility:
        return MaterialPageRoute(builder: (_) => const AccessibilityScreen());
      case financial:
        return MaterialPageRoute(builder: (_) => const FinancialServicesScreen());
      case counters:
        return MaterialPageRoute(builder: (_) => const FlightCountersScreen());
      case exploreShops:
        return MaterialPageRoute(builder: (_) => const ExploreShopsScreen());
      

      // ===== SEARCH SCREEN =====
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      // ===== MAP SCREEN =====
      case mapScreen:
        return MaterialPageRoute(builder: (_) => const MapScreen());

      // ===== DEFAULT / 404 =====
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                "404 - Page not found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
    }
  }
}