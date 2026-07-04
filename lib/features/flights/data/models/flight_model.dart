import 'package:equatable/equatable.dart';

class FlightAirlineModel extends Equatable {
  final String name;
  final String logo;

  const FlightAirlineModel({this.name = '', this.logo = ''});

  factory FlightAirlineModel.fromJson(Map<String, dynamic> json) {
    return FlightAirlineModel(
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [name, logo];
}

class FlightRouteModel extends Equatable {
  final String from;
  final String fromCode;
  final String to;
  final String toCode;

  const FlightRouteModel({
    this.from = '',
    this.fromCode = '',
    this.to = '',
    this.toCode = '',
  });

  factory FlightRouteModel.fromJson(Map<String, dynamic> json) {
    return FlightRouteModel(
      from: json['from'] as String? ?? '',
      fromCode: json['fromCode'] as String? ?? '',
      to: json['to'] as String? ?? '',
      toCode: json['toCode'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [from, fromCode, to, toCode];
}

class FlightScheduleModel extends Equatable {
  final String? terminal;
  final String? gate;
  final String? nodeId;
  final DateTime? scheduledTime;
  final DateTime? estimatedTime;
  final DateTime? actualTime;

  const FlightScheduleModel({
    this.terminal,
    this.gate,
    this.nodeId,
    this.scheduledTime,
    this.estimatedTime,
    this.actualTime,
  });

  factory FlightScheduleModel.fromJson(Map<String, dynamic> json) {
    return FlightScheduleModel(
      terminal: json['terminal'] as String?,
      gate: json['gate'] as String?,
      nodeId: json['nodeId'] as String?,
      scheduledTime: _parseDate(json['scheduledTime']),
      estimatedTime: _parseDate(json['estimatedTime']),
      actualTime: _parseDate(json['actualTime']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String).toLocal();
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [terminal, gate, scheduledTime, estimatedTime];
}

class FlightUpdateModel extends Equatable {
  final String id;
  final String updateType;
  final String field;
  final String before;
  final String after;
  final DateTime? timestamp;

  const FlightUpdateModel({
    this.id = '',
    this.updateType = '',
    this.field = '',
    this.before = '',
    this.after = '',
    this.timestamp,
  });

  factory FlightUpdateModel.fromJson(Map<String, dynamic> json) {
    return FlightUpdateModel(
      id: json['_id'] as String? ?? '',
      updateType: json['updateType'] as String? ?? '',
      field: json['field'] as String? ?? '',
      before: json['before'] as String? ?? '',
      after: json['after'] as String? ?? '',
      timestamp: FlightScheduleModel._parseDate(json['timestamp']),
    );
  }

  @override
  List<Object?> get props => [id, field, before, after];
}

class FlightModel extends Equatable {
  final String id;
  final String flightNumber;
  final String type;
  final String direction;
  final String status;
  final FlightAirlineModel airline;
  final FlightRouteModel route;
  final FlightScheduleModel departure;
  final FlightScheduleModel arrival;
  final List<FlightUpdateModel> updates;
  final bool isTracked;

  const FlightModel({
    this.id = '',
    this.flightNumber = '',
    this.type = '',
    this.direction = '',
    this.status = '',
    this.airline = const FlightAirlineModel(),
    this.route = const FlightRouteModel(),
    this.departure = const FlightScheduleModel(),
    this.arrival = const FlightScheduleModel(),
    this.updates = const [],
    this.isTracked = false,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      flightNumber: json['flightNumber'] as String? ?? '',
      type: json['type'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
      status: json['status'] as String? ?? '',
      airline: json['airline'] is Map
          ? FlightAirlineModel.fromJson(json['airline'] as Map<String, dynamic>)
          : const FlightAirlineModel(),
      route: json['route'] is Map
          ? FlightRouteModel.fromJson(json['route'] as Map<String, dynamic>)
          : const FlightRouteModel(),
      departure: json['departure'] is Map
          ? FlightScheduleModel.fromJson(
              json['departure'] as Map<String, dynamic>,
            )
          : const FlightScheduleModel(),
      arrival: json['arrival'] is Map
          ? FlightScheduleModel.fromJson(
              json['arrival'] as Map<String, dynamic>,
            )
          : const FlightScheduleModel(),
      updates:
          (json['updates'] as List<dynamic>?)
              ?.map(
                (e) => FlightUpdateModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }

  FlightModel copyWith({bool? isTracked}) {
    return FlightModel(
      id: id,
      flightNumber: flightNumber,
      type: type,
      direction: direction,
      status: status,
      airline: airline,
      route: route,
      departure: departure,
      arrival: arrival,
      updates: updates,
      isTracked: isTracked ?? this.isTracked,
    );
  }

  @override
  List<Object?> get props => [id, flightNumber, status, isTracked];
}
