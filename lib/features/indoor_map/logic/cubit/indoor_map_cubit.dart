import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';

class IndoorMapCubit extends Cubit<IndoorMapState> {
  final IndoorMapRepo repository;

  IndoorMapCubit({required this.repository}) : super(IndoorMapInitial());

  Future<void> loadServices() async {
    emit(IndoorMapLoading());

    try {
      final services = await repository.getServices();

      if (services.isEmpty) {
        emit(IndoorMapError("No services found"));
        return;
      }

      emit(
        IndoorMapLoaded(
          allServices: services,
          filteredServices: services,
          selectedZone: 'All',
        ),
      );
    } catch (e) {
      emit(IndoorMapError(e.toString()));
    }
  }

  void filterByZone(String zone) {
    final current = state;
    if (current is! IndoorMapLoaded) return;

    final filtered = _applyFilters(
      all: current.allServices,
      zone: zone,
      category: current.selectedCategory,
    );

    emit(
      current.copyWith(
        selectedZone: zone,
        filteredServices: filtered,
        clearSelectedService: true,
      ),
    );
  }

  void filterByCategory(String? category) {
    final current = state;
    if (current is! IndoorMapLoaded) return;

    final filtered = _applyFilters(
      all: current.allServices,
      zone: current.selectedZone,
      category: category,
    );

    emit(
      current.copyWith(
        filteredServices: filtered,
        selectedCategory: category,
        clearCategory: category == null,
        clearSelectedService: true,
      ),
    );
  }

  void selectService(MapServiceModel? service) {
    final current = state;
    if (current is! IndoorMapLoaded) return;
    emit(
      current.copyWith(
        selectedService: service,
        clearSelectedService: service == null,
      ),
    );
  }

  List<MapServiceModel> _applyFilters({
    required List<MapServiceModel> all,
    required String zone,
    String? category,
  }) {
    return all.where((s) {
      final zoneMatch = zone == 'All' || s.zone == zone;
      final categoryMatch = category == null || s.category == category;
      return zoneMatch && categoryMatch;
    }).toList();
  }
}
