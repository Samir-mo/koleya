import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/indoor_map/data/models/service_location_model.dart';
import 'package:gate_buddy/features/indoor_map/domain/airport_waypoints.dart';
import 'package:latlong2/latlong.dart';

enum MapCategory {
  all('ALL'),
  shops('SHOPS'),
  restaurants('RESTAURANTS'),
  vip('VIP'),
  services('SERVICES');

  const MapCategory(this.label);
  final String label;
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
  final List<ServiceLocationModel> allServices;
  final List<ServiceLocationModel> filteredServices;
  final MapCategory selectedCategory;
  final ServiceLocationModel? selectedService;
  final NavigationMode navigationMode;
  final IndoorRoute? activeRoute;
  final ServiceLocationModel? navigationDestination;
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
    List<ServiceLocationModel>? allServices,
    List<ServiceLocationModel>? filteredServices,
    MapCategory? selectedCategory,
    ServiceLocationModel? selectedService,
    bool clearSelected = false,
    NavigationMode? navigationMode,
    IndoorRoute? activeRoute,
    bool clearRoute = false,
    ServiceLocationModel? navigationDestination,
    bool clearDestination = false,
    int? currentStepIndex,
    LatLng? userPosition,
    int? simulationPointIndex,
  }) {
    return IndoorMapLoaded(
      allServices: allServices ?? this.allServices,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedService: clearSelected
          ? null
          : (selectedService ?? this.selectedService),
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
