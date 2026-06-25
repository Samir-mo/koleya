import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';
import 'package:gate_buddy/features/ai_chat/logic/cubit/ai_chat_cubit.dart';
import 'package:gate_buddy/features/ai_chat/ui/ai_chat_screen.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/ui/explore_places_screen.dart';
import 'package:gate_buddy/features/flights/ui/flights_screen.dart';
import 'package:gate_buddy/features/home/ui/home_screen.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/ui/indoor_map_screen.dart';
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
    _homeCubit = HomeCubit()..loadDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    _homeScrollController.dispose();
    _homeCubit.close();
    super.dispose();
  }

  // ── SCREENS ──────────────────────────────────────────────────────────────
  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (_) => getIt<IndoorMapCubit>()..loadServices(),
        child: const IndoorMapScreen(),
      ),
      const FlightsScreen(),
      BlocProvider.value(
        value: _homeCubit,
        child: HomeScreen(scrollController: _homeScrollController),
      ),
      BlocProvider(
        create: (_) => getIt<ExploreCubit>()..loadPlaces(),
        child: const ExplorePlacesScreen(),
      ),
      BlocProvider(
        create: (_) => getIt<AssistantCubit>(),
        child: const AssistantScreen(),
      ),
    ];
  }

  // ── NAV ITEMS ─────────────────────────────────────────────────────────────
  List<PersistentBottomNavBarItem> _navItems() {
    return [
      _buildItem(Icons.map_rounded, Icons.map_outlined),
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
      activeColorPrimary:
          isCenter ? const Color(0xFF00104A) : AppColors.primary400,
      inactiveColorPrimary: Colors.grey,
      title: isCenter ? 'Home' : null,
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
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10),
        colorBehindNavBar: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
    );
  }
}
