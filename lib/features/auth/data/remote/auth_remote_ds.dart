import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDs {
  final ApiConsumer api;

  const AuthRemoteDs({required this.api});

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.login,
        body: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.signup,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );
      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await api.get(ApiEndpoints.getProfile);
      final data = (response as Map<String, dynamic>)['data'];
      final userMap = data is Map ? data['user'] ?? data : data;
      return UserModel.fromJson(userMap as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<UserModel> updateMe(Map<String, dynamic> fields) async {
    try {
      final response = await api.patch(ApiEndpoints.updateMe, body: fields);
      final data = (response as Map<String, dynamic>)['data'];
      final userMap = data is Map ? data['user'] ?? data : data;
      return UserModel.fromJson(userMap as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> deleteMe() async {
    try {
      await api.delete(ApiEndpoints.deleteMe);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> logout() async {
    try {
      await api.post(ApiEndpoints.logout, body: {});
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await api.post(ApiEndpoints.forgetPassword, body: {'email': email});
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await api.post(
        ApiEndpoints.verifyResetCode,
        body: {'email': email, 'code': code},
      );
      final data = (response as Map<String, dynamic>)['data'];
      return (data is Map ? data['resetToken'] ?? data['token'] : '') as String? ?? '';
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<AuthResponseModel> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await api.patch(
        '${ApiEndpoints.resetPassword}/$resetToken',
        body: {'password': password, 'passwordConfirm': passwordConfirm},
      );
      return AuthResponseModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
