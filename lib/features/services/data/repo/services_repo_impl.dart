import 'package:gate_buddy/features/services/data/remote/services_remote_ds.dart';
import 'package:gate_buddy/features/services/data/repo/services_repo.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesRemoteDs remoteDs;
  ServicesRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getServices() => remoteDs.getServices();

  @override
  Future<dynamic> getServiceById(String id) => remoteDs.getServiceById(id);

  @override
  Future<dynamic> getVipLounges() => remoteDs.getVipLounges();
}
