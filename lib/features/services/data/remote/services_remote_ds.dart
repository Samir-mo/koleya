import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class ServicesRemoteDs {
  final ApiConsumer api;
  ServicesRemoteDs({required this.api});

  Future<dynamic> getServices() => api.get(ApiEndpoints.services);
  Future<dynamic> getServiceById(String id) =>
      api.get(ApiEndpoints.serviceById.replaceFirst(':id', id));
  Future<dynamic> getVipLounges() => api.get(ApiEndpoints.vipLounges);
}
