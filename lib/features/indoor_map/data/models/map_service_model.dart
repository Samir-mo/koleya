class MapServiceModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String status;
  final String terminal;
  final String? gate;
  final String zone; // used as floor
  final double rating;
  final List<String> images;
  final String operatingHours;
  final List<String> amenities;
  final List<String> services;
  final double latitude;
  final double longitude;
  final int waitTime;

  const MapServiceModel({
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
    required this.operatingHours,
    required this.amenities,
    required this.services,
    required this.latitude,
    required this.longitude,
    required this.waitTime,
  });

  factory MapServiceModel.fromJson(Map<String, dynamic> json) {
    // GeoJSON: coordinates = [longitude, latitude]
    final coords = json['location']['coordinates'] as List;
    return MapServiceModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      terminal: json['terminal'] as String,
      gate: json['gate'] as String?,
      zone: json['zone'] as String,
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      operatingHours: json['operatingHours'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      services: List<String>.from(json['services'] as List),
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
      waitTime: json['waitTime'] as int,
    );
  }
}
