import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

class SearchRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  const SearchRemoteDs({required this.api});

  Future<dynamic> search(String query) =>
      execute(() => api.get(
            ApiEndpoints.search,
            queryParameters: {'q': query},
          ));
}
