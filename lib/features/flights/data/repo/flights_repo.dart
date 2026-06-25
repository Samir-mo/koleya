abstract class FlightsRepo {
  Future<dynamic> getFlights();
  Future<dynamic> getUpdatedFlights();
  Future<dynamic> searchFlights(String query);
}
