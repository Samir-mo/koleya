import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';

import '../../core/api/api_endpoints.dart';

/// ✈️ FlightRepository — مسئول عن كل العمليات الخاصة بالرحلات
class FlightRepository {
  final ApiConsumer api;

  FlightRepository({required this.api});

  /// 🔹 البحث عن رحلات (GET /flights/search)
  /// [queryParams] يمكن أن تحتوي على flightNumber, destination, airline, إلخ.
  Future<Response> searchFlights([Map<String, dynamic>? queryParams]) async {
    try {
      final response = await api.get(
        ApiEndpoints.flightsSearch,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Search flights error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in searchFlights: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 الحصول على كل الرحلات (GET /flights)
  Future<Response> getFlights() async {
    try {
      final response = await api.get(ApiEndpoints.flights);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Get flights error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in getFlights: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 الحصول على الرحلات المحدّثة (GET /flights/updated)
  Future<Response> getUpdatedFlights() async {
    try {
      final response = await api.get(ApiEndpoints.flightsUpdated);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Get updated flights error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in getUpdatedFlights: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 جلب تفاصيل رحلة محددة (GET /flights/:id)
  Future<Response> getFlightById(String id) async {
    try {
      final endpoint = ApiEndpoints.flightById.replaceAll(":id", id);
      final response = await api.get(endpoint);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Get flight details error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in getFlightById: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 جلب الرحلات التي يتتبعها المستخدم (GET /flights/tracked)
  Future<Response> getTrackedFlights() async {
    try {
      final response = await api.get(ApiEndpoints.trackedFlights);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Get tracked flights error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in getTrackedFlights: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 تتبع رحلة معينة (POST /flights/:id/track)
  Future<Response> trackFlight(String id) async {
    try {
      final endpoint = ApiEndpoints.trackFlight.replaceAll(":id", id);
      final response = await api.post(endpoint);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Track flight error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in trackFlight: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 إلغاء تتبع رحلة (DELETE /flights/:id/track)
  Future<Response> untrackFlight(String id) async {
    try {
      final endpoint = ApiEndpoints.untrackFlight.replaceAll(":id", id);
      final response = await api.delete(endpoint);
      return response;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Untrack flight error";
      throw Exception("API Error: $msg");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error in untrackFlight: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }
}
