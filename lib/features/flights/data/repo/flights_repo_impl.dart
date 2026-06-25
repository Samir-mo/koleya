import 'package:gate_buddy/features/flights/data/remote/flights_remote_ds.dart';
import 'package:gate_buddy/features/flights/data/repo/flights_repo.dart';

class FlightsRepoImpl implements FlightsRepo {
  final FlightsRemoteDs remoteDs;
  FlightsRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getFlights() => remoteDs.getFlights();

  @override
  Future<dynamic> getUpdatedFlights() => remoteDs.getUpdatedFlights();

  @override
  Future<dynamic> searchFlights(String query) => remoteDs.searchFlights(query);
}
