import 'package:gate_buddy/features/flights/data/models/flight_model.dart';

import '../models/home_model.dart';

abstract class HomeRepo {
  Future<HomeModel> getHomeData();
  Future<List<FlightUpdateModel>> getFlightUpdates(String flightId);
}
