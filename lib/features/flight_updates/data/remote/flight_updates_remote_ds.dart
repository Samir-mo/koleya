import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/data/base_remote_ds.dart';

class FlightUpdatesRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  const FlightUpdatesRemoteDs({required this.api});

  Future<dynamic> getUpdatedFlights({
    int limit = 30,
    String sort = '-updatedAt',
    int page = 0,
  }) => execute(
    () => api.get(
      ApiEndpoints.flightsUpdated,
      queryParameters: {
        'limit': limit,
        'sort': sort,
        'page': page,
      },
    ),
  );
}
