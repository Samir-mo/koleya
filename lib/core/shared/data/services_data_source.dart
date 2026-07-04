import '../../api/api_consumer.dart';
import '../../api/api_endpoints.dart';
import '../../errors/error_handler.dart';
import '../models/service_model.dart';

/// Single source of truth for all /services API calls.
/// Both ExplorePlaces and IndoorMap features delegate to this class.
class ServicesDataSource {
  final ApiConsumer api;
  ServicesDataSource({required this.api});

  Future<List<ServiceModel>> getServices({
    String? category,
    int limit = 1000,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (category != null) query['category'] = category;
      query['limit'] = limit;

      final response = await api.get(
        ApiEndpoints.services,
        queryParameters: query.isEmpty ? null : query,
      );
      return _parseList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await api.get(
        ApiEndpoints.serviceById.replaceFirst(':id', id),
        queryParameters: {'includeReviews': 'true'},
      );
      final map = response as Map<String, dynamic>;
      final data = (map['data'] as Map<String, dynamic>?) ?? map;
      return ServiceModel.fromJson(
        (data['service'] as Map<String, dynamic>?) ?? data,
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<ServiceModel>> searchServices({
    required String query,
    String? category,
  }) async {
    try {
      final body = <String, dynamic>{'query': query};
      if (category != null) body['category'] = category;
      final response = await api.post(ApiEndpoints.servicesSearch, body: body);
      return _parseList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<ServiceModel>> filterServices({
    String? category,
    double? minRating,
    List<int>? priceLevel,
    bool? hasWifi,
    bool? hasUsb,
  }) async {
    try {
      final filters = <String, dynamic>{};
      if (category != null) filters['category'] = category;
      if (minRating != null) filters['minRating'] = minRating;
      if (priceLevel != null) filters['priceLevel'] = priceLevel;
      if (hasWifi != null) filters['hasWifi'] = hasWifi;
      if (hasUsb != null) filters['hasUSB'] = hasUsb;

      final response = await api.post(
        ApiEndpoints.servicesFilter,
        body: {'filters': filters},
      );
      return _parseList(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> rateService({
    required String id,
    required int rating,
    String? review,
  }) async {
    try {
      final body = <String, dynamic>{'rating': rating};
      if (review != null && review.isNotEmpty) body['review'] = review;
      await api.post(
        ApiEndpoints.rateService.replaceFirst(':id', id),
        body: body,
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  // ─── Shared response parser ───────────────────────────────────────────────

  List<ServiceModel> _parseList(dynamic response) {
    List<dynamic> raw = [];
    if (response is List) {
      raw = response;
    } else if (response is Map) {
      raw =
          (response['data'] as Map?)?['services'] as List? ??
          response['services'] as List? ??
          response['data'] as List? ??
          [];
    }
    return raw
        .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
