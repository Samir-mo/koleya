class PlaceModel {
  final int id;
  final String name;
  final String type; // Restaurant / Shop
  final String terminal;
  final String gate;
  final String description;
  final String image;
  final double rating;
  final String cuisine;
  final bool isOpen;

  PlaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.terminal,
    required this.gate,
    required this.description,
    required this.image,
    required this.rating,
    required this.cuisine,
    required this.isOpen,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      terminal: json['terminal'] ?? '',
      gate: json['gate'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      cuisine: json['cuisine'] ?? '',
      isOpen: json['is_open'] ?? true,
    );
  }
}
