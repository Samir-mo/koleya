import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/data/base_remote_ds.dart';
import '../models/home_model.dart';

class HomeRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  const HomeRemoteDs({required this.api});

  Future<HomeModel> getHomeData() => execute(() async {
    final response = await api.get(ApiEndpoints.home);
    return HomeModel.fromJson(response as Map<String, dynamic>);
  });
  // Returns the raw response — the endpoint's envelope shape (`data` as a
  // bare list vs. `data.updates`) is normalized in HomeRepoImpl, matching
  // TrackedFlightRepoImpl's handling of the same endpoint.
  Future<dynamic> getFlightUpdates(String flightId) => execute(
    () => api.get(ApiEndpoints.flightUpdates.replaceFirst(':id', flightId)),
  );
}
