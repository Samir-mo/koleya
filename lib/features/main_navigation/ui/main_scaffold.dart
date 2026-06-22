import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/cubit/home_cubit.dart';
import 'package:gate_buddy/features/flights/ui/flights_screen.dart';
import 'package:gate_buddy/features/home/ui/home_screen.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/ui/indoor_map_screen.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/explore_places_screen.dart';
import 'package:gate_buddy/ui/screens/assistant_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final PersistentTabController _controller;
  final ScrollController _homeScrollController = ScrollController();

  late final HomeCubit _homeCubit;

  static const int initialIndex = 2;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: initialIndex);

    // Create the cubit once here
    _homeCubit = HomeCubit(getIt())..loadDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    _homeScrollController.dispose();
    _homeCubit.close(); // Important: close it manually
    super.dispose();
  }

  // ---------------- SCREENS ----------------
  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) => getIt<IndoorMapCubit>()..loadServices(),
        child: const IndoorMapScreen(),
      ),
      const FlightsScreen(),

      // Use BlocProvider.value instead of creating new one every time
      BlocProvider.value(
        value: _homeCubit,
        child: HomeScreen(scrollController: _homeScrollController),
      ),

      const ExplorePlacesScreen(),
      const AssistantScreen(),
    ];
  }

  // ---------------- NAV ITEMS ----------------
  List<PersistentBottomNavBarItem> _navItems() {
    return [
      _buildItem(
        Icons.accessibility_new_rounded,
        Icons.accessibility_new_outlined,
      ),
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
      activeColorPrimary: isCenter
          ? const Color(0xFF00104A)
          : AppColors.primary400,
      inactiveColorPrimary: Colors.grey,
      title: isCenter ? "Home" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navItems(),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style9,
      confineToSafeArea: true,
      stateManagement: true, // keep this true
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
