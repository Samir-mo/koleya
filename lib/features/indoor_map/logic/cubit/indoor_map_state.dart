import 'package:equatable/equatable.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';
import 'package:gate_buddy/features/indoor_map/domain/airport_waypoints.dart';
import 'package:latlong2/latlong.dart';

enum MapCategory {
  all('ALL'),
  restaurants('RESTAURANTS'),
  shops('SHOPS'),
  vipServices('VIP_SERVICES'),
  financial('FINANCIAL'),
  counters('COUNTERS'),
  accessibility('ACCESSIBILITY');

  const MapCategory(this.value);
  final String value;

  String get label => switch (this) {
        MapCategory.all => 'All',
        MapCategory.restaurants => 'Dining',
        MapCategory.shops => 'Shops',
        MapCategory.vipServices => 'VIP',
        MapCategory.financial => 'Finance',
        MapCategory.counters => 'Counters',
        MapCategory.accessibility => 'Access',
      };
}

enum NavigationMode { none, routing, navigating }

abstract class IndoorMapState extends Equatable {
  const IndoorMapState();
  @override
  List<Object?> get props => [];
}

class IndoorMapInitial extends IndoorMapState {}

class IndoorMapLoading extends IndoorMapState {}

class IndoorMapLoaded extends IndoorMapState {
  final List<ServiceModel> allServices;
  final List<ServiceModel> filteredServices;
  final MapCategory selectedCategory;
  final ServiceModel? selectedService;
  final NavigationMode navigationMode;
  final IndoorRoute? activeRoute;
  final ServiceModel? navigationDestination;
  final int currentStepIndex;
  final LatLng userPosition;
  final int simulationPointIndex;

  const IndoorMapLoaded({
    required this.allServices,
    required this.filteredServices,
    required this.selectedCategory,
    this.selectedService,
    this.navigationMode = NavigationMode.none,
    this.activeRoute,
    this.navigationDestination,
    this.currentStepIndex = 0,
    this.userPosition = AirportWaypoints.userStart,
    this.simulationPointIndex = 0,
  });

  bool get isNavigating => navigationMode == NavigationMode.navigating;
  bool get hasRoute => activeRoute != null;

  RouteStep? get currentStep {
    final route = activeRoute;
    if (route == null) return null;
    if (currentStepIndex >= route.steps.length) return null;
    return route.steps[currentStepIndex];
  }

  bool get isLastStep {
    final route = activeRoute;
    if (route == null) return false;
    return currentStepIndex >= route.steps.length - 1;
  }

  IndoorMapLoaded copyWith({
    List<ServiceModel>? allServices,
    List<ServiceModel>? filteredServices,
    MapCategory? selectedCategory,
    ServiceModel? selectedService,
    bool clearSelected = false,
    NavigationMode? navigationMode,
    IndoorRoute? activeRoute,
    bool clearRoute = false,
    ServiceModel? navigationDestination,
    bool clearDestination = false,
    int? currentStepIndex,
    LatLng? userPosition,
    int? simulationPointIndex,
  }) {
    return IndoorMapLoaded(
      allServices: allServices ?? this.allServices,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedService:
          clearSelected ? null : (selectedService ?? this.selectedService),
      navigationMode: navigationMode ?? this.navigationMode,
      activeRoute: clearRoute ? null : (activeRoute ?? this.activeRoute),
      navigationDestination: clearDestination
          ? null
          : (navigationDestination ?? this.navigationDestination),
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      userPosition: userPosition ?? this.userPosition,
      simulationPointIndex: simulationPointIndex ?? this.simulationPointIndex,
    );
  }

  @override
  List<Object?> get props => [
        allServices,
        filteredServices,
        selectedCategory,
        selectedService,
        navigationMode,
        activeRoute,
        navigationDestination,
        currentStepIndex,
        userPosition,
        simulationPointIndex,
      ];
}

class IndoorMapError extends IndoorMapState {
  final String message;
  const IndoorMapError(this.message);
  @override
  List<Object?> get props => [message];
}
