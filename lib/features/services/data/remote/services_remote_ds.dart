import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

class ServicesRemoteDs {
  final ApiConsumer api;
  ServicesRemoteDs({required this.api});

  Future<dynamic> getServices() async {
    try {
      return await api.get(ApiEndpoints.services);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> getServiceById(String id) async {
    try {
      return await api.get(ApiEndpoints.serviceById.replaceFirst(':id', id));
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<dynamic> getVipLounges() async {
    try {
      return await api.get(ApiEndpoints.vipLounges);
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }
}
