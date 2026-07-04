import 'package:equatable/equatable.dart';

/// Unified model for airport services used by both Explore Places and Indoor Map.
class ServiceModel extends Equatable {
  final String id;
  final String name;

  /// Backend category field — uppercase: RESTAURANTS | SHOPS | VIP_SERVICES |
  /// FINANCIAL | COUNTERS | ACCESSIBILITY
  final String category;

  /// Sub-category used in FINANCIAL: ATMs | Currency Exchange | Insurance
  final String? subCategory;

  final String description;
  final String status; // 'open' | 'closed' | 'Unknown'
  final String airport;
  final String terminal;
  final String? gate;
  final String zone;
  final double rating;
  final List<String> images;
  final List<String> cuisine;
  final int priceLevel; // 1–4
  final String? hours; // operating hours string
  final bool? hasWifi;
  final bool? hasUsb;

  // Map-specific fields (0.0 when not available)
  final double latitude;
  final double longitude;
  final int waitTime;
  final List<String> amenities;
  final List<String> services;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    this.subCategory,
    required this.description,
    required this.status,
    required this.airport,
    required this.terminal,
    this.gate,
    required this.zone,
    required this.rating,
    required this.images,
    required this.cuisine,
    required this.priceLevel,
    this.hours,
    this.hasWifi,
    this.hasUsb,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.waitTime = 0,
    this.amenities = const [],
    this.services = const [],
  });

  // ─── Computed ─────────────────────────────────────────────────────────────

  bool get isOpen => status.toLowerCase() == 'open';
  bool get hasCoordinates => latitude != 0.0 && longitude != 0.0;
  String? get primaryImage => images.isNotEmpty ? images.first : null;

  String get categoryLabel {
    switch (category) {
      case 'RESTAURANTS':
        return 'Restaurant';
      case 'SHOPS':
        return 'Shop';
      case 'VIP_SERVICES':
        return 'VIP Lounge';
      case 'FINANCIAL':
        return subCategory ?? 'Financial';
      case 'COUNTERS':
        return 'Counter';
      case 'ACCESSIBILITY':
        return 'Accessibility';
      default:
        return category;
    }
  }

  // ─── fromJson ─────────────────────────────────────────────────────────────

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Coordinates — backend returns GeoJSON: { location: { coordinates: [lng, lat] } }
    final coords =
        json['location']?['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
    final lng = coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0;
    final lat = coords.length > 1 ? (coords[1] as num).toDouble() : 0.0;

    return ServiceModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category:
          (json['category'] ?? json['type'])?.toString().toUpperCase() ?? '',
      subCategory: json['subCategory']?.toString(),
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Unknown',
      airport: json['airport']?.toString() ?? '',
      terminal: json['terminal']?.toString() ?? '',
      gate: json['gate']?.toString(),
      zone: json['zone']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      images: _parseStringList(json['images']),
      cuisine: _parseStringList(json['cuisine']),
      priceLevel: (json['priceLevel'] as num?)?.toInt() ?? 1,
      hours: json['hours']?.toString() ?? json['operatingHours']?.toString(),
      hasWifi: json['hasWifi'] as bool?,
      hasUsb: json['hasUSB'] as bool?,
      latitude: lat,
      longitude: lng,
      waitTime: (json['waitTime'] as num?)?.toInt() ?? 0,
      amenities: _parseStringList(json['amenities']),
      services: _parseStringList(json['services']),
    );
  }

  static List<String> _parseStringList(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    subCategory,
    airport,
    terminal,
    rating,
  ];
}
