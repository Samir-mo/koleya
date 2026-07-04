import 'package:equatable/equatable.dart';

class AirportModel extends Equatable {
  final String code;
  final String name;
  final String operationHours;
  final String contactCenter;
  final bool wifi;
  final int parkingSpaces;

  const AirportModel({
    this.code = '',
    this.name = '',
    this.operationHours = '24/7',
    this.contactCenter = '',
    this.wifi = false,
    this.parkingSpaces = 0,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      operationHours: json['operationHours'] as String? ?? '24/7',
      contactCenter: json['contactCenter'] as String? ?? '',
      wifi: json['wifi'] as bool? ?? false,
      parkingSpaces: (json['parkingSpaces'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [code, name, contactCenter, wifi];
}
