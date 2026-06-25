import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class SearchRemoteDs {
  final ApiConsumer api;
  SearchRemoteDs({required this.api});

  Future<dynamic> search(String query) =>
      api.get(ApiEndpoints.search, queryParameters: {'q': query});
}
