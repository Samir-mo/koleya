import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

class ServicesRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  ServicesRemoteDs({required this.api});

  Future<dynamic> getServices() =>
      execute(() => api.get(ApiEndpoints.services));

  Future<dynamic> getServiceById(String id) =>
      execute(() => api.get(ApiEndpoints.serviceById.replaceFirst(':id', id)));

  Future<dynamic> getVipLounges() =>
      execute(() => api.get(ApiEndpoints.vipLounges));
}
