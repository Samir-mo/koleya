import 'package:gate_buddy/features/flights/data/models/flight_model.dart';

import '../models/home_model.dart';
import '../remote/home_remote_ds.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDs remoteDs;
  const HomeRepoImpl({required this.remoteDs});

  @override
  Future<HomeModel> getHomeData() => remoteDs.getHomeData();

  @override
  Future<List<FlightUpdateModel>> getFlightUpdates(String flightId) async {
    final raw = await remoteDs.getFlightUpdates(flightId);
    final data = raw is Map ? (raw['data'] ?? raw) : raw;
    final list = data is List ? data : (data['updates'] as List? ?? []);
    return list
        .map((e) => FlightUpdateModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
