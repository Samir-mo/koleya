import 'package:equatable/equatable.dart';

class BoardingPassData extends Equatable {
  final String passengerName;
  final String flightNumber;
  final String airlineCode;
  final String fromCode;
  final String toCode;
  final DateTime? departureDate;
  final String? seat;
  final String? pnr;
  final String rawData;

  const BoardingPassData({
    required this.passengerName,
    required this.flightNumber,
    required this.airlineCode,
    required this.fromCode,
    required this.toCode,
    required this.rawData,
    this.departureDate,
    this.seat,
    this.pnr,
  });

  @override
  List<Object?> get props =>
      [flightNumber, airlineCode, fromCode, toCode, departureDate];
}
