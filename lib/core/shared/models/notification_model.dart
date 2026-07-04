class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String? type; // نوع التنبيه (رحلة – خدمة – عام)
  final String? createdAt; // وقت الإشعار

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    if (type != null) "type": type,
    if (createdAt != null) "created_at": createdAt,
  };
}
