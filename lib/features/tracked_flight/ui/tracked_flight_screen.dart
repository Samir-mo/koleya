import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrackedFlightScreen extends StatelessWidget {
  final String flightNo;
  final String airline;
  final String status;
  final String gate;
  final String time;
  final String date;
  final String from;
  final String to;
  final String terminal;

  const TrackedFlightScreen({
    super.key,
    this.flightNo = '',
    this.airline = '',
    this.status = '',
    this.gate = '',
    this.time = '',
    this.date = '',
    this.from = '',
    this.to = '',
    this.terminal = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('tracked_flight.coming_soon'.tr())),
    );
  }
}
