import '../models/flight_model.dart';
import '../remote/flights_remote_ds.dart';
import 'flights_repo.dart';

class FlightsRepoImpl implements FlightsRepo {
  final FlightsRemoteDs remoteDs;

  FlightsRepoImpl({required this.remoteDs});

  @override
  Future<List<FlightModel>> getFlights({String? direction, String? status}) =>
      remoteDs.getFlights(direction: direction, status: status);

  @override
  Future<List<FlightModel>> getUpdatedFlights() =>
      remoteDs.getUpdatedFlights();

  @override
  Future<List<FlightModel>> searchFlights(String query) =>
      remoteDs.searchFlights(query);

  @override
  Future<FlightModel> getFlightById(String id) =>
      remoteDs.getFlightById(id);

  @override
  Future<void> trackFlight(String id) => remoteDs.trackFlight(id);

  @override
  Future<void> untrackFlight(String id) => remoteDs.untrackFlight(id);
}
