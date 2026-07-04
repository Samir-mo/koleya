import 'package:equatable/equatable.dart';
import '../../../flights/data/models/flight_model.dart';
import 'airport_model.dart';
import 'recommendation_model.dart';
import 'weather_model.dart';

class MyFlightResponseModel extends Equatable {
  final FlightModel flight;
  final String status;
  final bool isDelayed;
  final bool isCancelled;
  final int reminderMinutes;
  final WeatherModel weather;
  final WeatherModel weatherAtArrival;
  final List<RecommendationModel> recommendations;
  final AirportModel airport;
  final String arrivalTime;
  final String destinationLocalTime;
  final String localTime;

  const MyFlightResponseModel({
    this.flight = const FlightModel(),
    this.status = '',
    this.isDelayed = false,
    this.isCancelled = false,
    this.reminderMinutes = 0,
    this.weather = const WeatherModel(),
    this.weatherAtArrival = const WeatherModel(),
    this.recommendations = const [],
    this.airport = const AirportModel(),
    this.arrivalTime = '',
    this.destinationLocalTime = '',
    this.localTime = '',
  });

  factory MyFlightResponseModel.fromJson(Map<String, dynamic> json) {
    return MyFlightResponseModel(
      flight: json['flight'] is Map
          ? FlightModel.fromJson(json['flight'] as Map<String, dynamic>)
          : const FlightModel(),
      status: json['status'] as String? ?? '',
      isDelayed: json['isDelayed'] as bool? ?? false,
      isCancelled: json['isCancelled'] as bool? ?? false,
      reminderMinutes: (json['reminderMinutes'] as num?)?.toInt() ?? 0,
      weather: json['weather'] is Map
          ? WeatherModel.fromJson(json['weather'] as Map<String, dynamic>)
          : const WeatherModel(),
      weatherAtArrival: json['weatherAtArrival'] is Map
          ? WeatherModel.fromJson(
              json['weatherAtArrival'] as Map<String, dynamic>,
            )
          : const WeatherModel(),
      recommendations:
          (json['recommendations'] as List<dynamic>?)
              ?.map(
                (e) => RecommendationModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      airport: json['airport'] is Map
          ? AirportModel.fromJson(json['airport'] as Map<String, dynamic>)
          : const AirportModel(),
      arrivalTime: json['arrivalTime'] as String? ?? '',
      destinationLocalTime: json['destinationLocalTime'] as String? ?? '',
      localTime: json['localTime'] as String? ?? '',
    );
  }

  bool get hasWeather => weather.condition != 'Unavailable';
  bool get hasWeatherAtArrival => weatherAtArrival.condition != 'Unavailable';
  bool get hasRecommendations => recommendations.isNotEmpty;

  @override
  List<Object?> get props => [
    flight,
    status,
    isDelayed,
    isCancelled,
    recommendations,
    airport,
  ];
}
