import 'package:equatable/equatable.dart';

class RecommendationModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String image;
  final double rating;
  final String vicinity;
  final String googleMapsLink;

  const RecommendationModel({
    this.id = '',
    this.name = '',
    this.category = '',
    this.description = '',
    this.image = '',
    this.rating = 0.0,
    this.vicinity = '',
    this.googleMapsLink = '',
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      vicinity: json['vicinity'] as String? ?? '',
      googleMapsLink: json['googleMapsLink'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, rating, image];
}
