import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class HomeRemoteDs {
  final ApiConsumer api;
  HomeRemoteDs({required this.api});

  Future<dynamic> getHomeData() => api.get(ApiEndpoints.home);
}
