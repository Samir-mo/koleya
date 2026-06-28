import 'package:equatable/equatable.dart';

import 'user_model.dart';

class AuthResponseModel extends Equatable {
  final String token;
  final UserModel user;

  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Try every location the token could live in across common API shapes:
    //   { token, data: { user } }
    //   { data: { token, user } }
    //   { accessToken, data: { user } }
    //   { data: { accessToken, user } }
    final nested = json['data'] as Map<String, dynamic>?;

    final token = (json['token']
            ?? json['accessToken']
            ?? nested?['token']
            ?? nested?['accessToken']
            ?? '') as String;

    final userMap = (nested?['user']
            ?? json['user']
            ?? nested
            ?? <String, dynamic>{}) as Map<String, dynamic>;

    return AuthResponseModel(token: token, user: UserModel.fromJson(userMap));
  }

  @override
  List<Object?> get props => [token, user];
}
