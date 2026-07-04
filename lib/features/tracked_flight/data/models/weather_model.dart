import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String temperature;
  final String condition;

  const WeatherModel({
    this.temperature = '--',
    this.condition = 'Unavailable',
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temp']?.toString() ?? '--',
      condition: json['condition'] as String? ?? 'Unavailable',
    );
  }

  @override
  List<Object?> get props => [temperature, condition];
}
