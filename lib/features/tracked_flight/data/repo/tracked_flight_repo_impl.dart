import 'package:gate_buddy/features/tracked_flight/data/remote/tracked_flight_remote_ds.dart';
import 'package:gate_buddy/features/tracked_flight/data/repo/tracked_flight_repo.dart';

class TrackedFlightRepoImpl implements TrackedFlightRepo {
  final TrackedFlightRemoteDs remoteDs;
  TrackedFlightRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getTrackedFlights() => remoteDs.getTrackedFlights();

  @override
  Future<dynamic> trackFlight(String id) => remoteDs.trackFlight(id);

  @override
  Future<dynamic> untrackFlight(String id) => remoteDs.untrackFlight(id);
}
