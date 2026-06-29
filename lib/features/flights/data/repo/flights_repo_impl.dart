import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/flight_model.dart';
import '../remote/flights_remote_ds.dart';
import 'flights_repo.dart';

class FlightsRepoImpl implements FlightsRepo {
  final FlightsRemoteDs remoteDs;

  FlightsRepoImpl({required this.remoteDs});

  @override
  Future<List<FlightModel>> getFlights({String? direction, String? status}) async {
    try {
      return await remoteDs.getFlights(direction: direction, status: status);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<List<FlightModel>> getUpdatedFlights() async {
    try {
      return await remoteDs.getUpdatedFlights();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<List<FlightModel>> searchFlights(String query) async {
    try {
      return await remoteDs.searchFlights(query);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<FlightModel> getFlightById(String id) async {
    try {
      return await remoteDs.getFlightById(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> trackFlight(String id) async {
    try {
      return await remoteDs.trackFlight(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> untrackFlight(String id) async {
    try {
      return await remoteDs.untrackFlight(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<FlightModel> scanBoardingPass(String rawBoardingPassData) async {
    try {
      return await remoteDs.scanBoardingPass(
          rawBoardingPassData: rawBoardingPassData);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
