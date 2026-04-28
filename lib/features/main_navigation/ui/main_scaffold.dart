import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/core/di/dependency_injection.dart';
import 'package:koleya/core/themes/app_colors.dart';
import 'package:koleya/cubit/home_cubit.dart';
import 'package:koleya/features/home/ui/home_screen.dart';
import 'package:koleya/features/restaurants_and_shops/ui/explore_places_screen.dart';
import 'package:koleya/ui/screens/assistant_screen.dart';
import 'package:koleya/ui/screens/flights_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final PersistentTabController _controller;
  final ScrollController _homeScrollController = ScrollController();

  static const int initialIndex = 2;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    _homeScrollController.dispose();
    super.dispose();
  }

  // ---------------- SCREENS ----------------
  List<Widget> _buildScreens() {
    return [
      const Placeholder(),
      const FlightsScreen(),
      BlocProvider(
        create: (_) => HomeCubit(getIt())..loadDashboard(),
        child: HomeScreen(scrollController: _homeScrollController),
      ),

      const ExplorePlacesScreen(),
      const AssistantScreen(),
    ];
  }

  // ---------------- NAV ITEMS ----------------
  List<PersistentBottomNavBarItem> _navItems() {
    return [
      _buildItem(Icons.accessibility_new_rounded, Icons.accessibility_new_outlined),
      _buildItem(Icons.flight_takeoff_rounded, Icons.flight_takeoff_outlined),
      _buildItem(Icons.home_rounded, Icons.home_outlined, isCenter: true),
      _buildItem(Icons.storefront_rounded, Icons.storefront_outlined),
      _buildItem(Icons.smart_toy_rounded, Icons.smart_toy_outlined),
    ];
  }

  PersistentBottomNavBarItem _buildItem(
    IconData activeIcon,
    IconData inactiveIcon, {
    bool isCenter = false,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(activeIcon, size: 28),
      inactiveIcon: Icon(inactiveIcon, size: 26),
      activeColorPrimary: isCenter ? const Color(0xFF00104A) : AppColors.primary400,
      inactiveColorPrimary: Colors.grey,
      title: isCenter ? "Home" : null,
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navItems(),

      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style15,

      confineToSafeArea: true,
      stateManagement: true,

      hideNavigationBarWhenKeyboardAppears: true,

      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10),
        colorBehindNavBar: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),

      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
