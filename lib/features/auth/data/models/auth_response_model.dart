import 'package:equatable/equatable.dart';

import 'user_model.dart';

class AuthResponseModel extends Equatable {
  final String token;
  final UserModel user;

  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Supports multiple API shapes:
    //   { token, data: { user } }  |  { data: { token, user } }
    //   { accessToken, data: { user } }  |  { token, name, email, ... }
    final nested = json['data'] as Map<String, dynamic>?;

    final token =
        (json['token'] ??
                json['accessToken'] ??
                nested?['token'] ??
                nested?['accessToken'] ??
                '')
            as String;

    // Walk every plausible location for the user object; fall back to root.
    final userMap =
        nested?['user'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        nested ??
        json;

    return AuthResponseModel(token: token, user: UserModel.fromJson(userMap));
  }

  @override
  List<Object?> get props => [token, user];
}
