import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/ai_chat/logic/cubit/ai_chat_cubit.dart';
import 'package:gate_buddy/features/ai_chat/ui/ai_chat_screen.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/ui/explore_places_screen.dart';
import 'package:gate_buddy/features/flights/ui/flights_screen.dart';
import 'package:gate_buddy/features/home/logic/cubit/home_cubit.dart';
import 'package:gate_buddy/features/home/ui/home_screen.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/ui/indoor_map_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static final GlobalKey<MainScaffoldState> scaffoldKey =
      GlobalKey<MainScaffoldState>();

  static void jumpToTab(int index) =>
      scaffoldKey.currentState?._controller.jumpToTab(index);

  // Tab indices for MainScaffold.jumpToTab(...)
  static const int tabIndoorMap = 0;
  static const int tabFlights = 1;
  static const int tabHome = 2;
  static const int tabExplore = 3;
  static const int tabAssistant = 4;

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  late final PersistentTabController _controller;
  final ScrollController _homeScrollController = ScrollController();
  late final HomeCubit _homeCubit;

  static const int initialIndex = 2;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: initialIndex);
    _homeCubit = getIt<HomeCubit>()..loadDashboard();
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
      _buildItem(Icons.home_rounded, Icons.home_outlined),
      _buildItem(Icons.storefront_rounded, Icons.storefront_outlined),
      _buildItem(Icons.smart_toy_rounded, Icons.smart_toy_outlined),
    ];
  }

  PersistentBottomNavBarItem _buildItem(
    IconData activeIcon,
    IconData inactiveIcon,
  ) {
    return PersistentBottomNavBarItem(
      icon: Icon(activeIcon, size: rr(28)),
      inactiveIcon: Icon(inactiveIcon, size: rr(26)),
      activeColorPrimary: context.customColors.textSecondary,
      inactiveColorPrimary: context.customColors.textHint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navItems(),
      backgroundColor: context.customColors.background,
      navBarStyle: NavBarStyle.style9,
      confineToSafeArea: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(rr(10)),
        colorBehindNavBar: context.customColors.background,
        border: Border(top: BorderSide(color: context.customColors.border)),
      ),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
    );
  }
}

