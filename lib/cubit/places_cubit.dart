// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/repositories/places_repository.dart';
// import '../core/shared/models/place_model.dart';
// import 'places_state.dart';

// class PlacesCubit extends Cubit<PlacesState> {
//   final PlacesRepository _repo = PlacesRepository();

//   PlacesCubit() : super(PlacesInitial());

//   Future<void> loadPlaces() async {
//     emit(PlacesLoading());
//     try {
//       final response = await _repo.getPlaces();

//       final list = response.data is List
//           ? (response.data as List)
//               .map((e) => PlaceModel.fromJson(e))
//               .toList()
//               .cast<PlaceModel>() // 👈 نحول القائمة صراحةً
//           : <PlaceModel>[];

//       emit(PlacesLoaded(list));
//     } catch (e) {
//       emit(PlacesError(e.toString()));
//     }
//   }

//   Future<void> loadPlaceDetails(int id) async {
//     emit(PlacesLoading());
//     try {
//       // نحول الـid إلى String لأنه مكتوب في الريبو كـ String
//       final response = await _repo.getPlaceDetails(id.toString());
//       final data = response.data is Map ? response.data : {};
//       emit(PlaceDetailsLoaded(PlaceModel.fromJson(data)));
//     } catch (e) {
//       emit(PlacesError(e.toString()));
//     }
//   }
// }