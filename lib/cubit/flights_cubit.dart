import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/flight_repository.dart';
import '../core/shared/models/flight_model.dart';
import 'flights_state.dart';

class FlightsCubit extends Cubit<FlightsState> {
  final FlightRepository flightRepository;
  FlightsCubit(this.flightRepository) : super(FlightsInitial());

  Future<void> fetchFlights() async {
    emit(FlightsLoading());
    try {
      final response = await flightRepository.getFlights();

      List data = [];
      if (response.data is List) {
        data = response.data;
      } else if (response.data is Map && response.data["data"] is List) {
        data = response.data["data"];
      }

      final flights = data.map((e) => FlightModel.fromJson(e)).toList();
      emit(FlightsLoaded(flights));
    } catch (e) {
      emit(FlightsError(e.toString()));
    }
  }
}