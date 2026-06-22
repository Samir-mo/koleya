import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/explore_places/data/models/place_of_service_model.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<PlaceOfServiceModel> places;
  final List<PlaceOfServiceModel> filteredPlaces;
  final String? selectedCategory;

  const ExploreLoaded({
    required this.places,
    required this.filteredPlaces,
    this.selectedCategory,
  });

  ExploreLoaded copyWith({
    List<PlaceOfServiceModel>? places,
    List<PlaceOfServiceModel>? filteredPlaces,
    String? selectedCategory,
  }) {
    return ExploreLoaded(
      places: places ?? this.places,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [places, filteredPlaces, selectedCategory];
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);
}
