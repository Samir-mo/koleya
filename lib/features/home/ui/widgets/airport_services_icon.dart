import 'package:flutter/material.dart';

class AirportServicesIcon extends StatelessWidget {
  const AirportServicesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E0),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFF3A623), width: 1),
      ),
      child: const Center(child: Icon(Icons.local_airport, size: 11, color: Color(0xFFF3A623))),
    );
  }
}
