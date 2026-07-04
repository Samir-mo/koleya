import '../../../flights/data/models/flight_model.dart';
import '../remote/flight_updates_remote_ds.dart';
import 'flight_updates_repo.dart';

class FlightUpdatesRepoImpl implements FlightUpdatesRepo {
  final FlightUpdatesRemoteDs remoteDs;
  const FlightUpdatesRepoImpl({required this.remoteDs});

  @override
  Future<List<FlightModel>> getUpdatedFlights({
    int limit = 30,
    int page = 0,
  }) async {
    final raw = await remoteDs.getUpdatedFlights(
      limit: limit,
      page: page,
    );
    final data = raw is Map ? (raw['data'] ?? raw) : raw;
    final list = data is Map
        ? (data['flights'] as List? ?? [])
        : (data is List ? data : []);
    return list
        .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
