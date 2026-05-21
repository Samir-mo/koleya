import 'package:flutter/material.dart';
import 'package:gate_buddy/ui/screens/tracked_flight_screen.dart';

class FlightRow extends StatelessWidget {
  final Map<String, dynamic> flight;
  final Color primaryBlue;
  final Color accentOrange;
  final int index;

  const FlightRow({
    super.key,
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
          border: Border.all(color: const Color(0xFFE3E7F1), width: 1),
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
