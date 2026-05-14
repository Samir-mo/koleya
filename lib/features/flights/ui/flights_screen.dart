import 'package:flutter/material.dart';
import 'package:koleya/features/flights/ui/widgets/flights_tab.dart';

import '../../../core/shared/models/flight_model.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  static final List<FlightModel> mockFlights = [/* your mock data */];

  @override
  Widget build(BuildContext context) {
    final departureFlights = mockFlights
        .where((f) => f.from.toLowerCase().contains("nile international airport"))
        .toList();

    final arrivalFlights = mockFlights
        .where((f) => f.to.toLowerCase().contains("nile international airport"))
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flights'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Departure'),
              Tab(text: 'Arrival'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
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
