import 'package:gate_buddy/features/indoor_map/data/models/service_location_model.dart';
import 'package:gate_buddy/features/indoor_map/data/remote/indoor_map_remote_ds.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';

class IndoorMapRepoImpl implements IndoorMapRepo {
   final IndoorMapRemoteDs remoteDs;

  IndoorMapRepoImpl({required this.remoteDs});

  @override
  Future<List<ServiceLocationModel>> getServicesWithLocation({
    String? category,
  }) async {
    return remoteDs.getServicesWithLocation(category: category);
  }
}
