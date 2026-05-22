import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';

abstract class IndoorMapState {}

class IndoorMapInitial extends IndoorMapState {}

class IndoorMapLoading extends IndoorMapState {}

class IndoorMapLoaded extends IndoorMapState {
  final List<MapServiceModel> allServices;
  final List<MapServiceModel> filteredServices;
  final String selectedZone; // floor filter: 'All', '0', '1', '2'
  final String? selectedCategory; // category filter: null = all
  final MapServiceModel? selectedService; // tapped marker

  IndoorMapLoaded({
    required this.allServices,
    required this.filteredServices,
    required this.selectedZone,
    this.selectedCategory,
    this.selectedService,
  });

  IndoorMapLoaded copyWith({
    List<MapServiceModel>? allServices,
    List<MapServiceModel>? filteredServices,
    String? selectedZone,
    String? selectedCategory,
    MapServiceModel? selectedService,
    bool clearSelectedService = false,
    bool clearCategory = false,
  }) {
    return IndoorMapLoaded(
      allServices: allServices ?? this.allServices,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedZone: selectedZone ?? this.selectedZone,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedService: clearSelectedService
          ? null
          : (selectedService ?? this.selectedService),
    );
  }
}

class IndoorMapError extends IndoorMapState {
  final String message;
  IndoorMapError(this.message);
}
