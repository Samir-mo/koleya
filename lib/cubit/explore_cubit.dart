import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/places_repository.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final PlacesRepository _repository;

  ExploreCubit(this._repository) : super(ExploreInitial());

  /// تحميل الأماكن/المتاجر مع إمكانية تحديد الفئة
  Future<void> loadPlaces({String? category}) async {
    emit(ExploreLoading());
    try {
      final Response response = await _repository.getPlaces(
        queryParams: {
          if (category != null && category.isNotEmpty) "category": category,
        },
      );
      final List<dynamic> data = response.data["data"] ?? response.data;
      emit(ExploreLoaded(data));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }
}