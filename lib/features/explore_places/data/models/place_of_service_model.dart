import 'package:equatable/equatable.dart';

class PlaceOfServiceModel extends Equatable {
  final String id;
  final String name;
  final String
  type; // RESTAURANTS|SHOPS|ACCESSIBILITY|VIP_SERVICES|FINANCIAL|COUNTERS
  final String?
  subCategory; // e.g. ATMs|Currency Exchange|Insurance (for FINANCIAL)
  final String airport;
  final String terminal;
  final String description;
  final int priceLevel; // 1–4
  final String? hours;
  final double rating;
  final List<String> images;
  final bool? hasWifi;
  final bool? hasUsb;
  final List<String> cuisine;
  final String? status; // 'open' | 'closed'

  const PlaceOfServiceModel({
    required this.id,
    required this.name,
    required this.type,
    this.subCategory,
    required this.airport,
    required this.terminal,
    required this.description,
    required this.priceLevel,
    required this.rating,
    required this.images,
    required this.cuisine,
    this.hours,
    this.hasWifi,
    this.hasUsb,
    this.status,
  });

  bool get isOpen => status?.toLowerCase() == 'open';

  String? get primaryImage => images.isNotEmpty ? images.first : null;

  String get typeLabel {
    switch (type.toUpperCase()) {
      case 'RESTAURANTS':
        return 'Restaurant';
      case 'SHOPS':
        return 'Shop';
      case 'ACCESSIBILITY':
        return 'Accessibility';
      case 'VIP_SERVICES':
        return 'VIP Lounge';
      case 'FINANCIAL':
        return subCategory ?? 'Financial';
      case 'COUNTERS':
        return 'Counter';
      default:
        return type;
    }
  }

  factory PlaceOfServiceModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final imageList = rawImages is List
        ? rawImages.map((e) => e.toString()).toList()
        : <String>[];

    final rawCuisine = json['cuisine'];
    final cuisineList = rawCuisine is List
        ? rawCuisine.map((e) => e.toString()).toList()
        : <String>[];

    return PlaceOfServiceModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      // backend returns 'category' field (e.g. "SHOPS", "FINANCIAL")
      type: (json['category'] ?? json['type'])?.toString().toUpperCase() ?? '',
      subCategory: json['subCategory']?.toString(),
      airport: json['airport']?.toString() ?? '',
      terminal: json['terminal']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      priceLevel: (json['priceLevel'] as num?)?.toInt() ?? 1,
      hours: json['hours']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      images: imageList,
      hasWifi: json['hasWifi'] as bool?,
      hasUsb: json['hasUSB'] as bool?,
      cuisine: cuisineList,
      status: json['status']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    subCategory,
    airport,
    terminal,
    rating,
  ];
}
