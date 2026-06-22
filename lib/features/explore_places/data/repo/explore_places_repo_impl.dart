import 'package:gate_buddy/features/explore_places/data/models/place_of_service_model.dart';
import 'package:gate_buddy/features/explore_places/data/remote/explore_places_remote_ds.dart';
import 'package:gate_buddy/features/explore_places/data/repo/explore_places_repo.dart';

class ExplorePlacesRepoImpl implements ExplorePlacesRepo {
  final ExplorePlacesRemoteDs remoteDs;
  ExplorePlacesRepoImpl({required this.remoteDs});

  @override
  Future<List<PlaceOfServiceModel>> getPlacesOfService({String? category}) {
    return remoteDs.getPlaces(category: category);
  }
}
