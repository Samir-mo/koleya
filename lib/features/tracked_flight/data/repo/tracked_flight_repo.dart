abstract class TrackedFlightRepo {
  Future<dynamic> getTrackedFlights();
  Future<dynamic> trackFlight(String id);
  Future<dynamic> untrackFlight(String id);
}
