class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photo;

  const UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.photo = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        photo: json['photo'] ?? '',
      );
}
