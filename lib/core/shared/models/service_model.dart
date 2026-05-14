/// نموذج الخدمة ServiceModel
class ServiceModel {
  final int id;
  final String name;
  final String description;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
  });

  /// إنشاء نموذج من JSON (للبيانات الجاية من الـ API)
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  /// تحويل النموذج إلى JSON (لو هنرسل بيانات للسيرفر)
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };

  @override
  String toString() => 'Service(id: $id, name: $name, description: $description)';
}