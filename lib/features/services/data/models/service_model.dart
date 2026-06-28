class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String icon;
  final String location;

  const ServiceModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.category = '',
    this.icon = '',
    this.location = '',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        icon: json['icon'] ?? '',
        location: json['location'] ?? '',
      );
}
