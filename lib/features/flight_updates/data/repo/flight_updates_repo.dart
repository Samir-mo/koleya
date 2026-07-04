import '../../../flights/data/models/flight_model.dart';

abstract class FlightUpdatesRepo {
  Future<List<FlightModel>> getUpdatedFlights({
    int limit = 30,
    int page = 0,
  });
}
