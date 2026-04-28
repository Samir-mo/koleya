import 'package:flutter/material.dart';
import 'package:koleya/features/home/ui/home_screen.dart';
import 'package:koleya/features/home/ui/widgets/service_card.dart';
import 'package:koleya/ui/screens/accessibility_screen.dart';
import 'package:koleya/ui/screens/financial_services_screen.dart';
import 'package:koleya/ui/screens/flight_counters_screen.dart';
import 'package:koleya/ui/screens/vip_experience_screen.dart';

class AirportServicesGrid extends StatelessWidget {
  final Color primaryBlue;
  final Color accentOrange;

  const AirportServicesGrid({super.key, required this.primaryBlue, required this.accentOrange});

  @override
  Widget build(BuildContext context) {
    final items = [
      ServiceItem(
        title: 'Counters',
        icon: Icons.flight_takeoff_outlined,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FlightCountersScreen()));
        },
      ),
      ServiceItem(
        title: 'Vip Experience',
        icon: Icons.workspace_premium_outlined,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VipExperienceScreen()));
        },
      ),
      ServiceItem(
        title: 'Financial Services',
        icon: Icons.show_chart_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FinancialServicesScreen()),
          );
        },
      ),
      ServiceItem(
        title: 'Accessibility',
        icon: Icons.accessible_outlined,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AccessibilityScreen()));
        },
      ),
      ServiceItem(title: 'Shops', icon: Icons.storefront_outlined, onTap: () {}),
      ServiceItem(title: 'Restaurant', icon: Icons.restaurant_outlined, onTap: () {}),
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
                  Expanded(child: ServiceCard(item: items[row * 2])),
                  const SizedBox(width: 8),
                  Expanded(child: ServiceCard(item: items[row * 2 + 1])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
