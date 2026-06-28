import 'package:equatable/equatable.dart';

class UserPreferences extends Equatable {
  final bool darkMode;
  final String language;

  const UserPreferences({this.darkMode = false, this.language = 'en'});

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        darkMode: json['darkMode'] as bool? ?? false,
        language: json['language'] as String? ?? 'en',
      );

  Map<String, dynamic> toJson() => {'darkMode': darkMode, 'language': language};

  @override
  List<Object?> get props => [darkMode, language];
}

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photo;
  final UserPreferences preferences;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photo: json['photo'] as String?,
        preferences: json['preferences'] is Map
            ? UserPreferences.fromJson(
                json['preferences'] as Map<String, dynamic>)
            : const UserPreferences(),
      );

  UserModel copyWith({
    String? name,
    String? photo,
    UserPreferences? preferences,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        photo: photo ?? this.photo,
        preferences: preferences ?? this.preferences,
      );

  @override
  List<Object?> get props => [id, name, email, photo, preferences];
}
