import 'package:flutter/material.dart';

class TrackedFlightIcon extends StatelessWidget {
  const TrackedFlightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF3A623), width: 1),
      ),
      child: const Center(
        child: Icon(Icons.airplane_ticket_outlined, size: 12, color: Color(0xFFF3A623)),
      ),
    );
  }
}
