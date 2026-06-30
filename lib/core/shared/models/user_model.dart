class UserModel {
  final int id;
  final String name;
  final String email;
  final String? image; // الصورة اختيارية

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    if (image != null) "image": image,
  };
}
