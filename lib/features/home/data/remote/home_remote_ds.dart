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
  // Returns recently updated flights from `/flights/updated?limit=30&sort=-updatedAt`
  // Response shape: { data: { flights: [...full flight objects with updates...] } }
  Future<dynamic> getFlightUpdates() => execute(
    () => api.get(ApiEndpoints.flightsUpdated, queryParameters: {
      'limit': 30,
      'sort': '-updatedAt',
    }),
  );

  // Returns comprehensive flight data from `/flights/my-flight`
  Future<dynamic> getMyFlight() =>
      execute(() => api.get(ApiEndpoints.myFlight));
}
