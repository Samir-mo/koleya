import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';

abstract class IndoorMapRepo {
  Future<List<MapServiceModel>> getServices();
}
