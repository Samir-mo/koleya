import 'package:equatable/equatable.dart';

// ── Root ──────────────────────────────────────────────────────────────────────

class HomeModel extends Equatable {
  final UserTrackModel? userTrack;
  final List<UpdatedFlightModel> updatedFlights;
  final List<FeaturedServiceModel> featuredServices;
  final MetricsModel metrics;
  final List<String> categories;

  const HomeModel({
    this.userTrack,
    required this.updatedFlights,
    required this.featuredServices,
    required this.metrics,
    required this.categories,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return HomeModel(
      userTrack: data['userTrack'] != null
          ? UserTrackModel.fromJson(data['userTrack'] as Map<String, dynamic>)
          : null,
      updatedFlights: (data['updatedFlights'] as List<dynamic>? ?? [])
          .map((e) => UpdatedFlightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredServices: (data['featuredServices'] as List<dynamic>? ?? [])
          .map((e) => FeaturedServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      metrics: data['metrics'] != null
          ? MetricsModel.fromJson(data['metrics'] as Map<String, dynamic>)
          : MetricsModel.empty(),
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [userTrack, updatedFlights, featuredServices, metrics, categories];
}

// ── UserTrack ─────────────────────────────────────────────────────────────────

class UserTrackModel extends Equatable {
  final String id;
  final bool isActive;
  final int reminderMinutes;
  final TrackFlightModel flight;

  const UserTrackModel({
    required this.id,
    required this.isActive,
    required this.reminderMinutes,
    required this.flight,
  });

  factory UserTrackModel.fromJson(Map<String, dynamic> json) => UserTrackModel(
        id: json['_id'] as String? ?? '',
        isActive: json['isActive'] as bool? ?? false,
        reminderMinutes: json['reminderMinutes'] as int? ?? 0,
        flight: TrackFlightModel.fromJson(
            json['flight'] as Map<String, dynamic>? ?? {}),
      );

  @override
  List<Object?> get props => [id, isActive, reminderMinutes, flight];
}

class TrackFlightModel extends Equatable {
  final String id;
  final String flightNumber;
  final AirlineModel airline;
  final String status;
  final RouteModel route;
  final DepartureModel departure;
  final String? arrivalScheduledTime;

  const TrackFlightModel({
    this.id = '',
    required this.flightNumber,
    required this.airline,
    required this.status,
    required this.route,
    required this.departure,
    this.arrivalScheduledTime,
  });

  factory TrackFlightModel.fromJson(Map<String, dynamic> json) =>
      TrackFlightModel(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        flightNumber: json['flightNumber'] as String? ?? '',
        airline:
            AirlineModel.fromJson(json['airline'] as Map<String, dynamic>? ?? {}),
        status: json['status'] as String? ?? '',
        route:
            RouteModel.fromJson(json['route'] as Map<String, dynamic>? ?? {}),
        departure: DepartureModel.fromJson(
            json['departure'] as Map<String, dynamic>? ?? {}),
        arrivalScheduledTime:
            (json['arrival'] as Map<String, dynamic>?)?['scheduledTime']
                as String?,
      );

  @override
  List<Object?> get props =>
      [id, flightNumber, airline, status, route, departure, arrivalScheduledTime];
}

// ── UpdatedFlight ─────────────────────────────────────────────────────────────

class UpdatedFlightModel extends Equatable {
  final String id;
  final String flightNumber;
  final AirlineModel airline;
  final String status;
  final RouteModel route;
  final String? gate;
  final String? scheduledTime;

  const UpdatedFlightModel({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.status,
    required this.route,
    this.gate,
    this.scheduledTime,
  });

  factory UpdatedFlightModel.fromJson(Map<String, dynamic> json) {
    final dep = json['departure'] as Map<String, dynamic>?;
    return UpdatedFlightModel(
      id: json['_id'] as String? ?? '',
      flightNumber: json['flightNumber'] as String? ?? '',
      airline: AirlineModel.fromJson(
          json['airline'] as Map<String, dynamic>? ?? {}),
      status: json['status'] as String? ?? '',
      route: RouteModel.fromJson(json['route'] as Map<String, dynamic>? ?? {}),
      gate: dep?['gate'] as String?,
      scheduledTime: dep?['scheduledTime'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, flightNumber, airline, status, route, gate, scheduledTime];
}

// ── FeaturedService ───────────────────────────────────────────────────────────

class FeaturedServiceModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String zone;
  final String terminal;
  final double rating;
  final String operatingHours;
  final String description;

  const FeaturedServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.zone,
    required this.terminal,
    required this.rating,
    required this.operatingHours,
    required this.description,
  });

  factory FeaturedServiceModel.fromJson(Map<String, dynamic> json) =>
      FeaturedServiceModel(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? '',
        zone: json['zone'] as String? ?? '',
        terminal: json['terminal'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        operatingHours: json['operatingHours'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );

  @override
  List<Object?> get props =>
      [id, name, category, zone, terminal, rating, operatingHours, description];
}

// ── Metrics ───────────────────────────────────────────────────────────────────

class MetricsModel extends Equatable {
  final int activeUsers;
  final int flightsTracked;
  final int delays;
  final int airportsCovered;
  final String userRating;

  const MetricsModel({
    required this.activeUsers,
    required this.flightsTracked,
    required this.delays,
    required this.airportsCovered,
    required this.userRating,
  });

  factory MetricsModel.empty() => const MetricsModel(
        activeUsers: 0,
        flightsTracked: 0,
        delays: 0,
        airportsCovered: 0,
        userRating: '—',
      );

  factory MetricsModel.fromJson(Map<String, dynamic> json) => MetricsModel(
        activeUsers: json['activeUsers'] as int? ?? 0,
        flightsTracked: json['flightsTracked'] as int? ?? 0,
        delays: json['delays'] as int? ?? 0,
        airportsCovered: json['airportsCovered'] as int? ?? 0,
        userRating: json['userRating'] as String? ?? '—',
      );

  @override
  List<Object?> get props =>
      [activeUsers, flightsTracked, delays, airportsCovered, userRating];
}

// ── Shared sub-models ─────────────────────────────────────────────────────────

class AirlineModel extends Equatable {
  final String name;
  final String? logo;

  const AirlineModel({required this.name, this.logo});

  factory AirlineModel.fromJson(Map<String, dynamic> json) => AirlineModel(
        name: json['name'] as String? ?? '',
        logo: json['logo'] as String?,
      );

  @override
  List<Object?> get props => [name, logo];
}

class RouteModel extends Equatable {
  final String from;
  final String fromCode;
  final String to;
  final String toCode;

  const RouteModel({
    required this.from,
    required this.fromCode,
    required this.to,
    required this.toCode,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        from: json['from'] as String? ?? '',
        fromCode: json['fromCode'] as String? ?? '',
        to: json['to'] as String? ?? '',
        toCode: json['toCode'] as String? ?? '',
      );

  @override
  List<Object?> get props => [from, fromCode, to, toCode];
}

class DepartureModel extends Equatable {
  final String? terminal;
  final String? gate;
  final String? scheduledTime;
  final String? estimatedTime;
  final String? boardingTime;
  final String? checkInCounter;

  const DepartureModel({
    this.terminal,
    this.gate,
    this.scheduledTime,
    this.estimatedTime,
    this.boardingTime,
    this.checkInCounter,
  });

  factory DepartureModel.fromJson(Map<String, dynamic> json) => DepartureModel(
        terminal: json['terminal'] as String?,
        gate: json['gate'] as String?,
        scheduledTime: json['scheduledTime'] as String?,
        estimatedTime: json['estimatedTime'] as String?,
        boardingTime: json['boardingTime'] as String?,
        checkInCounter: json['checkInCounter'] as String?,
      );

  @override
  List<Object?> get props =>
      [terminal, gate, scheduledTime, estimatedTime, boardingTime, checkInCounter];
}
