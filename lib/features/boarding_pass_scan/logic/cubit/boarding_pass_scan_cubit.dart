import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/errors/failure.dart';
import 'package:gate_buddy/features/boarding_pass_scan/data/parser/bcbp_parser.dart';
import 'package:gate_buddy/features/boarding_pass_scan/logic/cubit/boarding_pass_scan_state.dart';
import 'package:gate_buddy/features/flights/data/repo/flights_repo.dart';

class BoardingPassScanCubit extends Cubit<BoardingPassScanState> {
  final FlightsRepo flightsRepo;

  BoardingPassScanCubit({required this.flightsRepo})
      : super(const BoardingPassScanState(
            status: BoardingPassScanStatus.scanning));

  void onBarcodeDetected(String raw) {
    if (state.status != BoardingPassScanStatus.scanning) return;
    emit(state.copyWith(status: BoardingPassScanStatus.parsing));

    final parsed = BcbpParser.parse(raw);
    if (parsed == null) {
      emit(state.copyWith(
        status: BoardingPassScanStatus.parseFailure,
        error: 'boarding_pass.failure_invalid',
      ));
      return;
    }
    emit(state.copyWith(
      status: BoardingPassScanStatus.parsed,
      data: parsed,
    ));
  }

  void resumeScanning() {
    emit(const BoardingPassScanState(
        status: BoardingPassScanStatus.scanning));
  }

  Future<void> submit() async {
    final data = state.data;
    if (data == null) return;

    emit(state.copyWith(status: BoardingPassScanStatus.submitting));
    try {
      final flight = await flightsRepo.scanBoardingPass(data.rawData);
      emit(state.copyWith(
        status: BoardingPassScanStatus.submitted,
        flight: flight,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BoardingPassScanStatus.failure,
        error: e is Failure
            ? e.message
            : 'boarding_pass.failure_network',
      ));
    }
  }
}
