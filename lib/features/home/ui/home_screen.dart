import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/cubit/home_cubit.dart';
import 'package:koleya/features/home/ui/widgets/home_dashboard.dart';

import '../../../data/repositories/dashboard_repository.dart';
// الشاشات التانية
import '../../../ui/screens/assistant_screen.dart';
import '../../../ui/screens/flights_screen.dart';
import '../../../ui/screens/profile_screen.dart';
import '../../../ui/screens/services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 2;

  final ScrollController _homeScrollController = ScrollController();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Placeholder(), // 0
      const AssistantScreen(), // 1
      HomeDashboard(scrollController: _homeScrollController), // 2 (Home)
      const FlightsScreen(), // 3
      const ServicesScreen(), // 4
      const ProfileScreen(), // 5
    ];
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(DashboardRepository())..loadDashboard(),
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: _pages),

        // ---------------- Bottom Bar ----------------
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            color: Colors.white,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                final indexMap = [0, 3, 2, 4, 1];
                final realIndex = indexMap[i];
                final bool isActive = currentIndex == realIndex;

                const List<IconData> icons = [
                  Icons.accessibility_new_outlined, // 0
                  Icons.flight_takeoff_outlined, // 3
                  Icons.home, // 2
                  Icons.storefront_outlined, // 4
                  Icons.smart_toy_outlined, // 1
                ];

                return Expanded(
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        if (currentIndex == realIndex &&
                            realIndex == 2 &&
                            _homeScrollController.hasClients) {
                          _homeScrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        } else {
                          currentIndex = realIndex;
                        }
                      });
                    },
                    icon: Icon(
                      icons[i],
                      size: 24,
                      color: isActive ? const Color(0xFF00104A) : Colors.grey.shade500,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ServiceItem({required this.title, required this.icon, required this.onTap});
}
