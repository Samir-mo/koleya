import 'package:flutter/material.dart';
import 'package:gate_buddy/core/shared/models/flight_model.dart';
import 'package:gate_buddy/ui/screens/tracked_flight_screen.dart';

class FlightCard extends StatelessWidget {
  final FlightModel info;
  const FlightCard({super.key, required this.info});

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('landed')) return Colors.green;
    if (lower.contains('departed')) return Colors.red;
    if (lower.contains('boarding')) return Colors.amber;
    if (lower.contains('in flight')) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(info.status);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrackedFlightScreen(
              flightNo: info.flightNo,
              airline: info.airline,
              status: info.status,
              gate: info.gate,
              time: info.time,
              date: info.date,
              from: info.from,
              to: info.to,
              terminal: info.terminal,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط أزرق صغير فوق الكارت
            Container(
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF003366),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // الصف الأول
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: info.logo.isNotEmpty
                                ? NetworkImage(info.logo)
                                : const AssetImage('assets/images/6.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Airline name + flight no
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.airline,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Flight No: ${info.flightNo}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Gate + Status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Gate: ${info.gate}',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 8, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                info.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.lock_outline, size: 18, color: Color(0xFF003366)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // الصف الثاني (من غير Overflow)
                  Row(
                    children: [
                      // Time + date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                info.time,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info.date,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      // Route + terminal (مرن)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${info.from}→${info.to}',
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'T${info.terminal}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
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
