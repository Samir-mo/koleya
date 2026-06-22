import 'package:gate_buddy/core/shared/models/service_model.dart';

class PlaceOfServiceModel extends ServiceModel {
  final String? image;
  final double? rating;
  final String? category;
  final String? zone;
  final bool isOpen;

  PlaceOfServiceModel({
    required super.id,
    required super.name,
    required super.description,
    this.image,
    this.rating,
    this.category,
    this.zone,
    this.isOpen = true,
  });

  factory PlaceOfServiceModel.fromJson(Map<String, dynamic> json) {
    return PlaceOfServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: (json['images'] as List?)?.isNotEmpty == true
          ? json['images'][0]
          : null,
      rating: (json['rating'] ?? 0.0).toDouble(),
      category: json['category']?.toString().toUpperCase(),
      zone: json['zone']?.toString(),
      isOpen: json['status']?.toString().toLowerCase() == 'open',
    );
  }
}
