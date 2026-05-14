import 'package:flutter/material.dart';
import 'package:koleya/core/shared/models/flight_model.dart';
import 'package:koleya/features/flights/ui/widgets/flight_card.dart';

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
