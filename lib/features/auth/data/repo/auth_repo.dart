import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRepo {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<UserModel> getMe();

  Future<UserModel> updateMe(Map<String, dynamic> fields);

  Future<void> deleteMe();

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<String> verifyResetCode({
    required String email,
    required String code,
  });

  Future<AuthResponseModel> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  });
}
