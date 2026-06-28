import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

class ProfileRemoteDs {
  final ApiConsumer api;
  ProfileRemoteDs({required this.api});

  Future<dynamic> getMe() async {
    try {
      return await api.get(ApiEndpoints.getProfile);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> updateMe(Map<String, dynamic> data) async {
    try {
      return await api.patch(ApiEndpoints.updateMe, body: data);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> updateMyPassword(Map<String, dynamic> data) async {
    try {
      return await api.patch(ApiEndpoints.updateMyPassword, body: data);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> deleteMe() async {
    try {
      return await api.delete(ApiEndpoints.deleteMe);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }
}
