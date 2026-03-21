import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:koleya/cubit/home_cubit.dart';
import 'package:koleya/cubit/home_state.dart';
import 'package:koleya/routes/app_routes.dart';
import 'package:koleya/ui/screens/accessibility_screen.dart';
import 'package:koleya/ui/screens/vip_experience_screen.dart';
import '../../data/repositories/dashboard_repository.dart';

// الشاشات التانية
import 'assistant_screen.dart';
import 'flights_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';
import 'tracked_flight_screen.dart';
import 'package:koleya/ui/screens/flight_counters_screen.dart';
import 'package:koleya/ui/screens/financial_services_screen.dart';

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
                      color: isActive
                          ? const Color(0xFF00104A)
                          : Colors.grey.shade500,
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

// ======================= HOME DASHBOARD =======================

class HomeDashboard extends StatelessWidget {
  final ScrollController? scrollController;
  const HomeDashboard({super.key, this.scrollController});

  Color get _primaryBlue => const Color(0xFF013F82);
  Color get _accentOrange => const Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Scaffold(
            backgroundColor: _primaryBlue,
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (state is HomeError) {
          return Scaffold(
            backgroundColor: _primaryBlue,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '❌ خطأ أثناء تحميل البيانات:\n${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
        }

        if (state is HomeLoaded) {
          final data = state.data;
          final List flights = data["updatedFlights"] ?? [];
          final Map? trackedFlight = data["trackedFlight"];

          return Scaffold(
            backgroundColor: _primaryBlue,
            body: SafeArea(
              child: Column(
                children: [
                  _HomeAppBar(primaryBlue: _primaryBlue),

                  // الجزء الأبيض اللي تحت
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== Updated Flights =====
                            _UpdatedFlightsSection(
                              flights: flights,
                              primaryBlue: _primaryBlue,
                              accentOrange: _accentOrange,
                            ),
                            const SizedBox(height: 24),

                            // ===== Your Tracked Flight =====
                            if (trackedFlight != null) ...[
                              _SectionTitle(
                                title: 'Your Tracked Flight',
                                color: _primaryBlue,
                                leading: const _TrackedFlightIcon(),
                              ),
                              const SizedBox(height: 10),
                              _TrackedFlightBigCard(
                                trackedFlight: trackedFlight,
                                primaryBlue: _primaryBlue,
                                accentOrange: _accentOrange,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // ===== Airport Services =====
                            _SectionTitle(
                              title: 'Airport Services',
                              color: _primaryBlue,
                              leading: const _AirportServicesIcon(),
                            ),
                            const SizedBox(height: 10),
                            _AirportServicesGrid(
                              primaryBlue: _primaryBlue,
                              accentOrange: _accentOrange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _primaryBlue,
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      },
    );
  }
}

// ======================= APP BAR =======================

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.primaryBlue});

  final Color primaryBlue;
  static const Color iconGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: primaryBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.search);
            },
            child: const Icon(
              Icons.search,
              color: iconGold,
              size: 28,
            ),
          ),
          const Text(
            'Gate buddy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Icon(
              Icons.person_outline,
              color: iconGold,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= SECTION TITLE =======================

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  final bool showDot;
  final Widget? leading;

  const _SectionTitle({
    required this.title,
    required this.color,
    this.showDot = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;
    if (showDot && leading == null) {
      effectiveLeading = Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(right: 6),
        decoration: const BoxDecoration(
          color: Color(0xFFF3A623),
          shape: BoxShape.circle,
        ),
      );
    }

    return Row(
      children: [
        if (effectiveLeading != null) ...[
          effectiveLeading,
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}

// أيقونة Your Tracked Flight (تذكرة صغيرة)
class _TrackedFlightIcon extends StatelessWidget {
  const _TrackedFlightIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFF3A623),
          width: 1,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.airplane_ticket_outlined,
          size: 12,
          color: Color(0xFFF3A623),
        ),
      ),
    );
  }
}

// أيقونة Airport Services
class _AirportServicesIcon extends StatelessWidget {
  const _AirportServicesIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E0),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFF3A623),
          width: 1,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.local_airport,
          size: 11,
          color: Color(0xFFF3A623),
        ),
      ),
    );
  }
}

// ======================= UPDATED FLIGHTS =======================

class _UpdatedFlightsSection extends StatelessWidget {
  final List flights;
  final Color primaryBlue;
  final Color accentOrange;

  const _UpdatedFlightsSection({
    required this.flights,
    required this.primaryBlue,
    required this.accentOrange,
  });

  @override
  Widget build(BuildContext context) {
    final list = flights.cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Updated Flights ✈️',
          color: primaryBlue,
          showDot: true,
        ),
        const SizedBox(height: 2),
        Text(
          'Stay informed about the latest flight and gate changes.',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),

        // الكارت الأبيض الكبير
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
            border: Border.all(color: const Color(0xFFE3E7F1)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < list.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == list.length - 1 ? 0 : 10,
                  ),
                  child: _FlightRow(
                    index: i,
                    flight: list[i],
                    primaryBlue: primaryBlue,
                    accentOrange: accentOrange,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // TODO: View all flights screen
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, right: 4),
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.orange.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlightRow extends StatelessWidget {
  final Map<String, dynamic> flight;
  final Color primaryBlue;
  final Color accentOrange;
  final int index;

  const _FlightRow({
    required this.flight,
    required this.primaryBlue,
    required this.accentOrange,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final route = (flight['route'] ?? '') as String;
    final status = (flight['status'] ?? '') as String;
    final airline = (flight['airline'] ?? 'Flight') as String;
    final flightNo = (flight['flight_no'] ?? '') as String;

    late final String beforeValue;
    late final String afterValue;
    late final String defaultStatus;

    if (index == 0) {
      beforeValue = 'Departure 10:30 AM';
      afterValue = 'Departure 11:00 AM';
      defaultStatus = 'Delayed';
    } else {
      beforeValue = 'Gate B12';
      afterValue = 'Gate C7';
      defaultStatus = 'Gate changed';
    }

    final String statusText = status.isEmpty ? defaultStatus : status;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrackedFlightScreen(
              flightNo: flightNo,
              airline: airline,
              status: statusText,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE3E7F1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الشريط الأزرق فوق
            Container(
              height: 18,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),

            // Flight + Route
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Flight: $flightNo',
                      style: const TextStyle(
                        color: Color(0xFF003A72),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        route,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF003A72),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Before / After + Chip
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Before / After
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Before: ',
                            style: const TextStyle(
                              color: Color(0xFF004780),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: beforeValue,
                                style: TextStyle(
                                  color: accentOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            text: 'After: ',
                            style: const TextStyle(
                              color: Color(0xFF004780),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: afterValue,
                                style: TextStyle(
                                  color: accentOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الـ Chip بتاعة الحالة (Delayed / Gate changed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1D4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 8,
                          height: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFFC68A2B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8E5B15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= TRACKED FLIGHT BIG CARD =======================

class _TrackedFlightBigCard extends StatelessWidget {
  final Map trackedFlight;
  final Color primaryBlue;
  final Color accentOrange;

  const _TrackedFlightBigCard({
    required this.trackedFlight,
    required this.primaryBlue,
    required this.accentOrange,
  });

  @override
  Widget build(BuildContext context) {
    final String airline = (trackedFlight['airline'] ?? 'Egypt Air') as String;
    final String flightNo = (trackedFlight['flight_no'] ?? 'MS359') as String;
    final String time = (trackedFlight['time'] ?? '11:25') as String;
    final String status =
        (trackedFlight['status'] ?? 'Boarding in 20 minutes') as String;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E7F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // الشريط الأزرق في أعلى الكارت
          Container(
            height: 18,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),

          // بيانات الرحلة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFDFD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE3E7F1)),
            ),
            child: Row(
              children: [
                // لوجو + اسم
                Expanded(
                  child: Row(
                    children: [
                      // هنا ممكن تحط لوجو شركة الطيران
                      // Image.asset('assets/...'),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            airline,
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Flight No: $flightNo',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.flight_takeoff,
                          size: 14,
                          color: Color(0xFFF3A623),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1D4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 8,
                            height: 8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFFC68A2B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8E5B15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // زرار Explore Destination
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrackedFlightScreen(
                      flightNo: flightNo,
                      airline: airline,
                      status: status,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentOrange,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.public,
                      size: 11,
                      color: accentOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Explore Destination',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // زرار Cancel Tracking
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {
                // TODO: cancel tracking logic
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentOrange, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close,
                    size: 16,
                    color: accentOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel Tracking',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= AIRPORT SERVICES GRID =======================

class _AirportServicesGrid extends StatelessWidget {
  final Color primaryBlue;
  final Color accentOrange;

  const _AirportServicesGrid({
    required this.primaryBlue,
    required this.accentOrange,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _ServiceItem(
        title: 'Counters',
        icon: Icons.flight_takeoff_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FlightCountersScreen(),
            ),
          );
        },
      ),
      _ServiceItem(
        title: 'Vip Experience',
        icon: Icons.workspace_premium_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VipExperienceScreen()),
          );
        },
      ),
      _ServiceItem(
        title: 'Financial Services',
        icon: Icons.show_chart_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FinancialServicesScreen(),
            ),
          );
        },
      ),
      _ServiceItem(
        title: 'Accessibility',
        icon: Icons.accessible_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccessibilityScreen()),
          );
        },
      ),
      _ServiceItem(
        title: 'Shops',
        icon: Icons.storefront_outlined,
        onTap: () {},
      ),
      _ServiceItem(
        title: 'Restaurant',
        icon: Icons.restaurant_outlined,
        onTap: () {},
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E7F1)),
      ),
      child: Column(
        children: [
          for (int row = 0; row < 3; row++)
            Padding(
              padding: EdgeInsets.only(bottom: row == 2 ? 0 : 8),
              child: Row(
                children: [
                  Expanded(child: _ServiceCard(item: items[row * 2])),
                  const SizedBox(width: 8),
                  Expanded(child: _ServiceCard(item: items[row * 2 + 1])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _ServiceItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem item;
  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E7F1)),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 22,
              color: const Color(0xFFF3A623),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003A72),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
