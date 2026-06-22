import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/features/indoor_map/data/models/service_location_model.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';
import 'package:gate_buddy/features/indoor_map/domain/airport_waypoints.dart';
import 'package:gate_buddy/features/indoor_map/domain/indoor_routing_service.dart';
import 'package:latlong2/latlong.dart';

import 'indoor_map_state.dart';

class IndoorMapCubit extends Cubit<IndoorMapState> {
  final IndoorMapRepo indoorMapRepo;
  Timer? _simulationTimer;

  IndoorMapCubit({required this.indoorMapRepo}) : super(IndoorMapInitial());

  // ─── Load services ────────────────────────────────────────────────────────

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

  // ─── Filter ───────────────────────────────────────────────────────────────

  void filterByCategory(MapCategory category) {
    final s = state;
    if (s is! IndoorMapLoaded) return;
    final filtered = category == MapCategory.all
        ? s.allServices
        : s.allServices
              .where((x) => x.category.toUpperCase() == category.label)
              .toList();
    emit(
      s.copyWith(
        filteredServices: filtered,
        selectedCategory: category,
        clearSelected: true,
      ),
    );
  }

  // ─── Marker selection ─────────────────────────────────────────────────────

  void selectService(ServiceLocationModel service) {
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

  void startNavigation(ServiceLocationModel destination) {
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

      // Advance step if we passed a step's waypoint
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

  // ─── Retry ────────────────────────────────────────────────────────────────

  Future<void> retry() => loadServices();

  @override
  Future<void> close() {
    _simulationTimer?.cancel();
    return super.close();
  }
}
