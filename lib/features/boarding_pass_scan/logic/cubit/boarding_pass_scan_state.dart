import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/boarding_pass_scan/data/models/boarding_pass_data.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';

enum BoardingPassScanStatus {
  initial,
  scanning,
  parsing,
  parseFailure,
  parsed,
  submitting,
  submitted,
  failure,
}

class BoardingPassScanState extends Equatable {
  final BoardingPassScanStatus status;
  final BoardingPassData? data;
  final String? error;
  final FlightModel? flight;

  const BoardingPassScanState({
    this.status = BoardingPassScanStatus.initial,
    this.data,
    this.error,
    this.flight,
  });

  BoardingPassScanState copyWith({
    BoardingPassScanStatus? status,
    BoardingPassData? data,
    String? error,
    FlightModel? flight,
  }) {
    return BoardingPassScanState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      flight: flight ?? this.flight,
    );
  }

  @override
  List<Object?> get props => [status, data, error, flight];
}
