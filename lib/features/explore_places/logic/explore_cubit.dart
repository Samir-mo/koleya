import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/features/explore_places/data/repo/explore_places_repo.dart';

import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExplorePlacesRepo repo;

  ExploreCubit({required this.repo}) : super(ExploreInitial());

  Future<void> loadPlaces() async {
    emit(ExploreLoading());
    try {
      final places = await repo.getPlacesOfService();
      emit(ExploreLoaded(places: places, filteredPlaces: places));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }

  void filterByCategory(String? category) {
    final s = state;
    if (s is! ExploreLoaded) return;

    final filtered = category == null
        ? s.places
        : s.places.where((p) => p.category == category).toList();

    emit(s.copyWith(filteredPlaces: filtered, selectedCategory: category));
  }

  void search(String query) {
    final s = state;
    if (s is! ExploreLoaded) return;

    final filtered = s.places
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    emit(s.copyWith(filteredPlaces: filtered));
  }
}
