class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    this.id = '',
    this.title = '',
    this.body = '',
    this.isRead = false,
    this.createdAt = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'] ?? '',
      );
}
