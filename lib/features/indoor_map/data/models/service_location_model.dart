/// Model for a service/shop/restaurant with location data
/// Maps to GET /api/v1/services response
class ServiceLocationModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String status;
  final String terminal;
  final String? gate;
  final String zone;
  final double rating;
  final List<String> images;
  final List<String> cuisine;
  final int waitTime;
  final String operatingHours;
  final List<String> amenities;
  final List<String> services;
  final double latitude;
  final double longitude;

  const ServiceLocationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.status,
    required this.terminal,
    this.gate,
    required this.zone,
    required this.rating,
    required this.images,
    required this.cuisine,
    required this.waitTime,
    required this.operatingHours,
    required this.amenities,
    required this.services,
    required this.latitude,
    required this.longitude,
  });

  bool get isOpen => status.toLowerCase() == 'open';

  String get firstImage => images.isNotEmpty ? images.first : '';

  /// GeoJSON format: coordinates = [longitude, latitude]
  factory ServiceLocationModel.fromJson(Map<String, dynamic> json) {
    final coords =
        json['location']?['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
    return ServiceLocationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: (json['category'] ?? '').toString().toUpperCase(),
      description: json['description'] ?? '',
      status: json['status'] ?? 'Unknown',
      terminal: json['terminal'] ?? '',
      gate: json['gate'],
      zone: json['zone']?.toString() ?? '0',
      rating: (json['rating'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      cuisine: List<String>.from(json['cuisine'] ?? []),
      waitTime: json['waitTime'] ?? 0,
      operatingHours: json['operatingHours'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      // GeoJSON: [lng, lat] → we need lat first for LatLng
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
    );
  }
}
