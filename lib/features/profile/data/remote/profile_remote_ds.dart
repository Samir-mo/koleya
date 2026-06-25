import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';

class ProfileRemoteDs {
  final ApiConsumer api;
  ProfileRemoteDs({required this.api});

  Future<dynamic> getMe() => api.get(ApiEndpoints.getProfile);
  Future<dynamic> updateMe(Map<String, dynamic> data) =>
      api.patch(ApiEndpoints.updateMe, body: data);
  Future<dynamic> updateMyPassword(Map<String, dynamic> data) =>
      api.patch(ApiEndpoints.updateMyPassword, body: data);
  Future<dynamic> deleteMe() => api.delete(ApiEndpoints.deleteMe);
}
