import 'package:flutter/material.dart';
import 'package:gate_buddy/features/home/ui/widgets/flight_row.dart';
import 'package:gate_buddy/features/home/ui/widgets/section_title.dart';

class UpdatedFlightsSection extends StatelessWidget {
  final List flights;
  final Color primaryBlue;
  final Color accentOrange;

  const UpdatedFlightsSection({
    super.key,
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
        SectionTitle(
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
                  child: FlightRow(
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
