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
  Future<List<FlightModel>> getFlightUpdates() async {
    final raw = await remoteDs.getFlightUpdates();
    final data = raw is Map ? (raw['data'] ?? raw) : raw;
    final list = data is Map
        ? (data['flights'] as List? ?? [])
        : (data is List ? data : []);
    return list
        .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
