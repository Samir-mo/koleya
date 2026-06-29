import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/tracked_flight/data/remote/tracked_flight_remote_ds.dart';
import 'package:gate_buddy/features/tracked_flight/data/repo/tracked_flight_repo.dart';

class TrackedFlightRepoImpl implements TrackedFlightRepo {
  final TrackedFlightRemoteDs remoteDs;
  TrackedFlightRepoImpl({required this.remoteDs});

  @override
  Future<List<FlightModel>> getTrackedFlights() async {
    try {
      final raw = await remoteDs.getTrackedFlights();
      final data = raw is Map ? (raw['data'] ?? raw) : raw;
      final list = data is List ? data : (data['flights'] as List? ?? []);
      return list
          .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> trackFlight(String id, {String? boardingPassNumber}) async {
    try {
      await remoteDs.trackFlight(id, boardingPassNumber: boardingPassNumber);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> untrackFlight(String id) async {
    try {
      await remoteDs.untrackFlight(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<List<FlightUpdateModel>> getFlightUpdates(String id) async {
    try {
      final raw = await remoteDs.getFlightUpdates(id);
      final data = raw is Map ? (raw['data'] ?? raw) : raw;
      final list = data is List ? data : (data['updates'] as List? ?? []);
      return list
          .map((e) => FlightUpdateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
