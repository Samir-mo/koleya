import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDs with BaseRemoteDs {
  final ApiConsumer api;

  const AuthRemoteDs({required this.api});

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) =>
      execute(() async {
        final response = await api.post(
          ApiEndpoints.login,
          body: {'email': email, 'password': password},
        );
        return AuthResponseModel.fromJson(response as Map<String, dynamic>);
      });

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) =>
      execute(() async {
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
      });

  Future<UserModel> getMe() =>
      execute(() async {
        final response = await api.get(ApiEndpoints.getProfile);
        final data = (response as Map<String, dynamic>)['data'];
        final userMap = data is Map ? data['user'] ?? data : data;
        return UserModel.fromJson(userMap as Map<String, dynamic>);
      });

  Future<UserModel> updateMe(Map<String, dynamic> fields) =>
      execute(() async {
        final response = await api.patch(ApiEndpoints.updateMe, body: fields);
        final data = (response as Map<String, dynamic>)['data'];
        final userMap = data is Map ? data['user'] ?? data : data;
        return UserModel.fromJson(userMap as Map<String, dynamic>);
      });

  Future<void> deleteMe() =>
      execute(() => api.delete(ApiEndpoints.deleteMe));

  Future<void> logout() =>
      execute(() => api.post(ApiEndpoints.logout, body: {}));

  Future<void> forgotPassword({required String email}) =>
      execute(() => api.post(ApiEndpoints.forgetPassword, body: {'email': email}));

  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) =>
      execute(() async {
        final response = await api.post(
          ApiEndpoints.verifyResetCode,
          body: {'email': email, 'code': code},
        );
        final data = (response as Map<String, dynamic>)['data'];
        return (data is Map ? data['resetToken'] ?? data['token'] : '') as String? ?? '';
      });

  Future<AuthResponseModel> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  }) =>
      execute(() async {
        final response = await api.patch(
          '${ApiEndpoints.resetPassword}/$resetToken',
          body: {'password': password, 'passwordConfirm': passwordConfirm},
        );
        return AuthResponseModel.fromJson(response as Map<String, dynamic>);
      });
}
