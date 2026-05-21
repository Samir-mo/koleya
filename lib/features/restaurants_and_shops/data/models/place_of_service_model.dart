class PlaceOfServiceModel {
  final int id;
  final String name;
  final String type;
  final double rating;
  final String openHours;
  final String cuisine;
  final String? imagePath;

  const PlaceOfServiceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.openHours,
    required this.cuisine,
    required this.imagePath,
  });
}
