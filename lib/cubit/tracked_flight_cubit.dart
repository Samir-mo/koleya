import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tracked_flight_repository.dart';
import '../../data/models/tracked_flight_model.dart';
import 'tracked_flight_state.dart';

class TrackedFlightCubit extends Cubit<TrackedFlightState> {
  final TrackedFlightRepository _repo = TrackedFlightRepository();

  TrackedFlightCubit() : super(TrackedFlightInitial());

  Future<void> loadFlight(String flightNo) async {
    emit(TrackedFlightLoading());
    try {
      final response = await _repo.getFlightDetails(flightNo);

      final data = response.data;
      final flight = data is Map
          ? TrackedFlightModel.fromJson(
              data["data"] ?? data,
            )
          : TrackedFlightModel.fromJson(data);

      emit(TrackedFlightLoaded(flight));
    } catch (e) {
      emit(TrackedFlightError(e.toString()));
    }
  }
}