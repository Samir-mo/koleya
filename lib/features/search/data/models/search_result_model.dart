import 'package:equatable/equatable.dart';

enum SearchResultType { flight, service, place, unknown }

class SearchResultModel extends Equatable {
  final String id;
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String? badge;
  final String? badgeColor;
  final Map<String, dynamic> raw;

  const SearchResultModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    required this.raw,
  });

  static List<SearchResultModel> fromResponse(dynamic response) {
    final results = <SearchResultModel>[];
    if (response == null) return results;

    final data = response is Map ? (response['data'] ?? response) : response;

    // flights
    final flights = data['flights'] as List<dynamic>? ?? [];
    for (final f in flights) {
      final m = f as Map<String, dynamic>;
      final route = m['route'] as Map<String, dynamic>? ?? {};
      final airline = m['airline'] as Map<String, dynamic>? ?? {};
      results.add(
        SearchResultModel(
          id: m['_id'] as String? ?? '',
          type: SearchResultType.flight,
          title: '${m['flightNumber'] ?? ''} — ${airline['name'] ?? ''}',
          subtitle: '${route['fromCode'] ?? ''} → ${route['toCode'] ?? ''}',
          badge: m['status'] as String?,
          raw: m,
        ),
      );
    }

    // services
    final services = data['services'] as List<dynamic>? ?? [];
    for (final s in services) {
      final m = s as Map<String, dynamic>;
      results.add(
        SearchResultModel(
          id: m['_id'] as String? ?? '',
          type: SearchResultType.service,
          title: m['name'] as String? ?? '',
          subtitle:
              '${m['category'] ?? ''} · ${m['zone'] ?? m['terminal'] ?? ''}',
          badge: m['category'] as String?,
          raw: m,
        ),
      );
    }

    // places
    final places = data['places'] as List<dynamic>? ?? [];
    for (final p in places) {
      final m = p as Map<String, dynamic>;
      results.add(
        SearchResultModel(
          id: m['_id'] as String? ?? '',
          type: SearchResultType.place,
          title: m['name'] as String? ?? '',
          subtitle: m['description'] as String? ?? '',
          raw: m,
        ),
      );
    }

    // flat list fallback (if API returns a single array)
    if (flights.isEmpty && services.isEmpty && places.isEmpty) {
      final list = data is List
          ? data
          : (data['results'] as List<dynamic>? ?? []);
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final kind = (m['type'] ?? m['kind'] ?? '') as String;
        SearchResultType t = SearchResultType.unknown;
        if (kind.toLowerCase().contains('flight')) t = SearchResultType.flight;
        if (kind.toLowerCase().contains('service'))
          t = SearchResultType.service;
        if (kind.toLowerCase().contains('place')) t = SearchResultType.place;
        results.add(
          SearchResultModel(
            id: m['_id'] as String? ?? '',
            type: t,
            title: m['name'] ?? m['flightNumber'] ?? '',
            subtitle: m['description'] ?? m['status'] ?? '',
            raw: m,
          ),
        );
      }
    }

    return results;
  }

  @override
  List<Object?> get props => [id, type, title];
}
