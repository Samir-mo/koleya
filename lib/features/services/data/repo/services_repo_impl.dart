import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/features/services/data/remote/services_remote_ds.dart';
import 'package:gate_buddy/features/services/data/repo/services_repo.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesRemoteDs remoteDs;
  ServicesRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getServices() async {
    try {
      return await remoteDs.getServices();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> getServiceById(String id) async {
    try {
      return await remoteDs.getServiceById(id);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> getVipLounges() async {
    try {
      return await remoteDs.getVipLounges();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
