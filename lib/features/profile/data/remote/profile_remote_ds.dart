import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

class ProfileRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  ProfileRemoteDs({required this.api});

  Future<dynamic> getMe() =>
      execute(() => api.get(ApiEndpoints.getProfile));

  Future<dynamic> updateMe(Map<String, dynamic> data) =>
      execute(() => api.patch(ApiEndpoints.updateMe, body: data));

  Future<dynamic> updateMyPassword(Map<String, dynamic> data) =>
      execute(() => api.patch(ApiEndpoints.updateMyPassword, body: data));

  Future<dynamic> deleteMe() =>
      execute(() => api.delete(ApiEndpoints.deleteMe));
}
