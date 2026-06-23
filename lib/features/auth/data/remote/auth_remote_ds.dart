import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_endpoints.dart';

class AuthRemoteDs {
  final ApiConsumer api;

  AuthRemoteDs({required this.api});

  Future<dynamic> login({required String email, required String password}) {
    return api.post(
      ApiEndpoints.login,
      body: {"email": email, "password": password},
    );
  }

  Future<dynamic> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return api.post(
      ApiEndpoints.signup,
      body: {"name": name, "email": email, "password": password},
    );
  }

  Future<dynamic> forgetPassword({required String email}) {
    return api.post(ApiEndpoints.forgetPassword, body: {"email": email});
  }

  Future<dynamic> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) {
    return api.patch(
      "${ApiEndpoints.resetPassword}/$token",
      body: {"password": password, "passwordConfirm": passwordConfirm},
    );
  }

  Future<dynamic> updateMyPassword({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  }) {
    return api.patch(
      ApiEndpoints.updateMyPassword,
      body: {
        "passwordCurrent": currentPassword,
        "password": password,
        "passwordConfirm": passwordConfirm,
      },
    );
  }

  Future<dynamic> getMe() {
    return api.get(ApiEndpoints.me);
  }

  Future<dynamic> updateMe(Map<String, dynamic> userData) {
    return api.patch(ApiEndpoints.updateMe, body: userData);
  }

  Future<dynamic> deleteMe() {
    return api.delete(ApiEndpoints.deleteMe);
  }
}
