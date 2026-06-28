import 'package:equatable/equatable.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<ServiceModel> allPlaces;
  final List<ServiceModel> displayedPlaces;
  final String? selectedType;         // null = All
  final String? selectedSubCategory;  // only used when selectedType == 'FINANCIAL'
  final String searchQuery;
  final bool isSearching;
  final bool isRating;
  final String? ratingError;
  final bool ratingSuccess;

  const ExploreLoaded({
    required this.allPlaces,
    required this.displayedPlaces,
    this.selectedType,
    this.selectedSubCategory,
    this.searchQuery = '',
    this.isSearching = false,
    this.isRating = false,
    this.ratingError,
    this.ratingSuccess = false,
  });

  List<ServiceModel> get topRated {
    final sorted = [...allPlaces]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(10).toList();
  }

  ExploreLoaded copyWith({
    List<ServiceModel>? allPlaces,
    List<ServiceModel>? displayedPlaces,
    String? selectedType,
    bool clearType = false,
    String? selectedSubCategory,
    bool clearSubCategory = false,
    String? searchQuery,
    bool? isSearching,
    bool? isRating,
    String? ratingError,
    bool clearRatingError = false,
    bool? ratingSuccess,
  }) {
    return ExploreLoaded(
      allPlaces: allPlaces ?? this.allPlaces,
      displayedPlaces: displayedPlaces ?? this.displayedPlaces,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedSubCategory: clearSubCategory
          ? null
          : (selectedSubCategory ?? this.selectedSubCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      isRating: isRating ?? this.isRating,
      ratingError: clearRatingError ? null : (ratingError ?? this.ratingError),
      ratingSuccess: ratingSuccess ?? this.ratingSuccess,
    );
  }

  @override
  List<Object?> get props => [
        allPlaces,
        displayedPlaces,
        selectedType,
        selectedSubCategory,
        searchQuery,
        isSearching,
        isRating,
        ratingError,
        ratingSuccess,
      ];
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);
  @override
  List<Object?> get props => [message];
}
