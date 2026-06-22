import 'package:gate_buddy/features/explore_places/data/models/place_of_service_model.dart';

abstract class ExplorePlacesRepo {
  Future<List<PlaceOfServiceModel>> getPlacesOfService({String? category});
}
