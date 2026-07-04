import '../../../../core/shared/models/service_model.dart';

abstract class IndoorMapRepo {
  Future<List<ServiceModel>> getServicesWithLocation({String? category});
}
