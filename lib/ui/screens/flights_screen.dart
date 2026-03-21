import 'package:flutter/material.dart';
import 'package:koleya/ui/screens/tracked_flight_screen.dart';
import '../../data/models/flight_model.dart';
import 'package:koleya/routes/app_routes.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  // 🔹 بيانات وهمية للعرض بس – عدّلها زي ما تحب
  static final List<FlightModel> mockFlights = [
    FlightModel(
      flightNo: 'MS123',
      airline: 'EgyptAir',
      status: 'Departed',
      gate: 'A12',
      time: '14:30',
      date: '2025-01-01',
      from: 'Nile International Airport',
      to: 'Dubai International Airport',
      terminal: '1',
      logo: '',
    ),
    FlightModel(
      flightNo: 'MS456',
      airline: 'Nile Air',
      status: 'Landed',
      gate: 'B5',
      time: '16:00',
      date: '2025-01-01',
      from: 'Cairo International Airport',
      to: 'Nile International Airport',
      terminal: '2',
      logo: '',
    ),
    FlightModel(
      flightNo: 'MS789',
      airline: 'Fly Emirates',
      status: 'Boarding',
      gate: 'C3',
      time: '18:15',
      date: '2025-01-01',
      from: 'Nile International Airport',
      to: 'Riyadh Airport',
      terminal: '1',
      logo: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // فلترة حسب from/to عشان Departure / Arrival
    final departureFlights = mockFlights
        .where((f) => f.from
            .toLowerCase()
            .contains("nile international airport".toLowerCase()))
        .toList();

    final arrivalFlights = mockFlights
        .where((f) => f.to
            .toLowerCase()
            .contains("nile international airport".toLowerCase()))
        .toList();

    return DefaultTabController(
      length: 2, // Departure & Arrival
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Flights',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Nile International Airport',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            indicatorWeight: 3,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Departure'),
              Tab(text: 'Arrival'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FlightsTab(flights: departureFlights),
            FlightsTab(flights: arrivalFlights),
          ],
        ),
      ),
    );
  }
}

// *************************
//   FlightsTab (UI فقط)
// *************************
class FlightsTab extends StatelessWidget {
  final List<FlightModel> flights;

  const FlightsTab({super.key, required this.flights});

  @override
  Widget build(BuildContext context) {
    if (flights.isEmpty) {
      return const Center(child: Text('لا توجد رحلات حالياً'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: flights.length,
      itemBuilder: (context, index) => FlightCard(info: flights[index]),
    );
  }
}

// *************************
//   FlightCard
// *************************
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط أزرق صغير فوق الكارت
            Container(
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF003366),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
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
                                : const AssetImage('assets/images/placeholder.png')
                                    as ImageProvider,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Flight No: ${info.flightNo}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
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
                      const Icon(
                        Icons.lock_outline,
                        size: 18,
                        color: Color(0xFF003366),
                      ),
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
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                info.time,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
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
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'T${info.terminal}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
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
          ],
        ),
      ),
    );
  }
}
