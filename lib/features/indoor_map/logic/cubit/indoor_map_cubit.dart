import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/models/service_model.dart';
import '../../data/repo/indoor_map_repo.dart';
import '../../domain/airport_waypoints.dart';
import '../../domain/indoor_routing_service.dart';
import 'package:latlong2/latlong.dart';

import 'indoor_map_state.dart';

class IndoorMapCubit extends Cubit<IndoorMapState> {
  final IndoorMapRepo indoorMapRepo;
  Timer? _simulationTimer;

  IndoorMapCubit({required this.indoorMapRepo}) : super(IndoorMapInitial());

  // ─── Load ─────────────────────────────────────────────────────────────────

  Future<void> loadServices() async {
    emit(IndoorMapLoading());
    try {
      final services = await indoorMapRepo.getServicesWithLocation();
      emit(
        IndoorMapLoaded(
          allServices: services,
          filteredServices: services,
          selectedCategory: MapCategory.all,
        ),
      );
    } catch (e) {
      emit(IndoorMapError(e.toString()));
    }
  }

  // ─── Filter — hits API with category param just like Explore Places ─────

  Future<void> filterByCategory(MapCategory category) async {
    final s = state;
    if (s is! IndoorMapLoaded) return;

    // Optimistic UI: show selected chip immediately, keep current markers
    emit(s.copyWith(selectedCategory: category, clearSelected: true));

    try {
      final categoryParam = category == MapCategory.all ? null : category.value;
      final services = await indoorMapRepo.getServicesWithLocation(
        category: categoryParam,
      );

      final loaded = state;
      if (loaded is! IndoorMapLoaded) return;
      emit(
        loaded.copyWith(
          allServices: category == MapCategory.all
              ? services
              : loaded.allServices,
          filteredServices: services,
          selectedCategory: category,
        ),
      );
    } catch (e) {
      emit(IndoorMapError(e.toString()));
    }
  }

  // ─── Selection ────────────────────────────────────────────────────────────

  void selectService(ServiceModel service) {
    final s = state;
    if (s is! IndoorMapLoaded) return;
    if (s.selectedService?.id == service.id) {
      emit(s.copyWith(clearSelected: true));
    } else {
      emit(s.copyWith(selectedService: service));
    }
  }

  void clearSelection() {
    final s = state;
    if (s is! IndoorMapLoaded) return;
    emit(s.copyWith(clearSelected: true));
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void startNavigation(ServiceModel destination) {
    final s = state;
    if (s is! IndoorMapLoaded) return;

    final route = IndoorRoutingService.buildRoute(
      userPos: s.userPosition,
      destination: destination,
    );

    emit(
      s.copyWith(
        navigationMode: NavigationMode.navigating,
        activeRoute: route,
        navigationDestination: destination,
        currentStepIndex: 0,
        simulationPointIndex: 0,
        clearSelected: true,
      ),
    );

    _startSimulation();
  }

  void cancelNavigation() {
    _simulationTimer?.cancel();
    final s = state;
    if (s is! IndoorMapLoaded) return;
    emit(
      s.copyWith(
        navigationMode: NavigationMode.none,
        clearRoute: true,
        clearDestination: true,
        currentStepIndex: 0,
        simulationPointIndex: 0,
        userPosition: AirportWaypoints.userStart,
      ),
    );
  }

  void nextStep() {
    final s = state;
    if (s is! IndoorMapLoaded) return;
    if (s.isLastStep) return;
    emit(s.copyWith(currentStepIndex: s.currentStepIndex + 1));
  }

  // ─── Simulation ───────────────────────────────────────────────────────────

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      final s = state;
      if (s is! IndoorMapLoaded) {
        _simulationTimer?.cancel();
        return;
      }

      final route = s.activeRoute;
      if (route == null) return;

      final nextIdx = s.simulationPointIndex + 1;
      if (nextIdx >= route.polylinePoints.length) {
        _simulationTimer?.cancel();
        return;
      }

      final nextPos = route.polylinePoints[nextIdx];
      int stepIdx = s.currentStepIndex;
      if (stepIdx < route.steps.length - 1) {
        final stepPoint = route.steps[stepIdx].point;
        if (_isNear(nextPos, stepPoint)) {
          stepIdx = (stepIdx + 1).clamp(0, route.steps.length - 1);
        }
      }

      emit(
        s.copyWith(
          userPosition: nextPos,
          simulationPointIndex: nextIdx,
          currentStepIndex: stepIdx,
        ),
      );
    });
  }

  bool _isNear(LatLng a, LatLng b, {double thresholdDeg = 0.0003}) {
    return (a.latitude - b.latitude).abs() < thresholdDeg &&
        (a.longitude - b.longitude).abs() < thresholdDeg;
  }

  Future<void> retry() => loadServices();

  @override
  Future<void> close() {
    _simulationTimer?.cancel();
    return super.close();
  }
}
