import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/features/tracked_flight/data/remote/tracked_flight_remote_ds.dart';
import 'package:gate_buddy/features/tracked_flight/data/repo/tracked_flight_repo.dart';

class TrackedFlightRepoImpl implements TrackedFlightRepo {
  final TrackedFlightRemoteDs remoteDs;
  TrackedFlightRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getTrackedFlights() async {
    try {
      return await remoteDs.getTrackedFlights();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> trackFlight(String id) async {
    try {
      return await remoteDs.trackFlight(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> untrackFlight(String id) async {
    try {
      return await remoteDs.untrackFlight(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
