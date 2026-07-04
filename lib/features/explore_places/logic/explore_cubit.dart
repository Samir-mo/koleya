import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/shared/models/service_model.dart';
import '../data/repo/explore_places_repo.dart';

import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExplorePlacesRepo repo;
  Timer? _searchDebounce;

  ExploreCubit({required this.repo}) : super(const ExploreInitial());

  Future<void> loadPlaces({String? category}) async {
    final currentLoaded = state is ExploreLoaded
        ? state as ExploreLoaded
        : null;

    if (currentLoaded != null) {
      emit(
        currentLoaded.copyWith(
          isSearching: true,
          selectedType: category,
          clearType: category == null,
          clearSubCategory: true,
          searchQuery: '',
        ),
      );
    } else {
      emit(const ExploreLoading());
    }

    final result = await repo.getPlaces(category: category);
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (places) => emit(
        ExploreLoaded(
          allPlaces: places,
          displayedPlaces: places,
          selectedType: category,
          isSearching: false,
        ),
      ),
    );
  }

  Future<void> selectType(String? category) async {
    await loadPlaces(category: category);
  }

  void selectSubCategory(String? subCategory) {
    final s = state;
    if (s is! ExploreLoaded) return;

    final filtered = subCategory == null
        ? s.allPlaces
        : s.allPlaces
              .where(
                (p) =>
                    p.subCategory?.toLowerCase() == subCategory.toLowerCase(),
              )
              .toList();

    emit(
      s.copyWith(
        displayedPlaces: filtered,
        selectedSubCategory: subCategory,
        clearSubCategory: subCategory == null,
      ),
    );
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.isEmpty) {
      _clearSearch();
      return;
    }
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(searchQuery: query, isSearching: true));

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  void _clearSearch() {
    final s = state;
    if (s is! ExploreLoaded) return;
    final filtered = s.selectedType == null
        ? s.allPlaces
        : s.allPlaces
              .where(
                (p) =>
                    p.category.toLowerCase() == s.selectedType!.toLowerCase(),
              )
              .toList();
    emit(
      s.copyWith(
        displayedPlaces: filtered,
        searchQuery: '',
        isSearching: false,
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    final s = state;
    if (s is! ExploreLoaded) return;

    final filtered = s.allPlaces.where((p) {
      final q = query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.terminal.toLowerCase().contains(q);
    }).toList();

    emit(
      s.copyWith(
        displayedPlaces: filtered,
        searchQuery: query,
        isSearching: false,
      ),
    );
  }

  Future<void> ratePlace({
    required ServiceModel place,
    required int rating,
    String? review,
  }) async {
    final s = state;
    if (s is! ExploreLoaded) return;

    emit(
      s.copyWith(isRating: true, clearRatingError: true, ratingSuccess: false),
    );

    final result = await repo.ratePlace(
      id: place.id,
      rating: rating,
      review: review,
    );

    result.fold(
      (failure) => emit(
        (state as ExploreLoaded).copyWith(
          isRating: false,
          ratingError: failure.message,
          ratingSuccess: false,
        ),
      ),
      (_) => emit(
        (state as ExploreLoaded).copyWith(
          isRating: false,
          clearRatingError: true,
          ratingSuccess: true,
        ),
      ),
    );
  }

  void clearRatingResult() {
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(clearRatingError: true, ratingSuccess: false));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
