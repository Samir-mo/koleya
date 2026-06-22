import 'package:gate_buddy/features/indoor_map/data/models/service_location_model.dart';

abstract class IndoorMapRepo {
  Future<List<ServiceLocationModel>> getServicesWithLocation({
    String? category,
  });
}
