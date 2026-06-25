import 'package:flutter_bloc/flutter_bloc.dart';
import 'flights_state.dart';

class FlightsCubit extends Cubit<FlightsState> {
  FlightsCubit() : super(const FlightsInitial());

  Future<void> fetchFlights() async {}
  Future<void> fetchUpdatedFlights() async {}
  Future<void> searchFlights(String query) async {}
}
