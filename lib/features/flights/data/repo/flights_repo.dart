import '../models/flight_model.dart';

abstract class FlightsRepo {
  Future<List<FlightModel>> getFlights({String? direction, String? status});
  Future<List<FlightModel>> getUpdatedFlights();
  Future<List<FlightModel>> searchFlights(String query);
  Future<FlightModel> getFlightById(String id);
  Future<void> trackFlight(String id);
  Future<void> untrackFlight(String id);
  Future<FlightModel> scanBoardingPass(String rawBoardingPassData);
}
