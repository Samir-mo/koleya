import 'package:flutter/material.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';

class TrackedFlightBigCard extends StatelessWidget {
  final Map trackedFlight;
  final Color primaryBlue;
  final Color accentOrange;

  const TrackedFlightBigCard({
    super.key,
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
            color: Colors.black.withValues(alpha: 0.03),
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
                      border: Border.all(color: accentOrange, width: 1.2),
                    ),
                    child: Icon(Icons.public, size: 11, color: accentOrange),
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
                  Icon(Icons.close, size: 16, color: accentOrange),
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
