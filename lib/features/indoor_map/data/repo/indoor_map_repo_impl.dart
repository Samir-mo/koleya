import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';
import 'package:gate_buddy/features/indoor_map/data/remote/indoor_map_remote_ds.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';

class IndoorMapRepoImpl implements IndoorMapRepo {
  final IndoorMapRemoteDs remoteDS;

  IndoorMapRepoImpl({required this.remoteDS});
  @override
  Future<List<MapServiceModel>> getServices() async {
    try {
      return await remoteDS.getServices();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
