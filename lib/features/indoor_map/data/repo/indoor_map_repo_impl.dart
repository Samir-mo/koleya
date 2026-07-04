import '../../../../core/shared/data/services_data_source.dart';
import '../../../../core/shared/models/service_model.dart';
import 'indoor_map_repo.dart';

class IndoorMapRepoImpl implements IndoorMapRepo {
  final ServicesDataSource dataSource;
  IndoorMapRepoImpl({required this.dataSource});

  @override
  Future<List<ServiceModel>> getServicesWithLocation({String? category}) async {
    final all = await dataSource.getServices(category: category);
    return all.where((s) => s.hasCoordinates).toList();
  }
}
