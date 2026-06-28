import 'package:gate_buddy/core/errors/error_handler.dart';
import 'package:gate_buddy/core/service/secure_storage.dart';
import 'package:gate_buddy/core/utils/app_constants.dart';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../remote/auth_remote_ds.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDs remoteDs;
  final SecureStorage storage;

  const AuthRepoImpl({required this.remoteDs, required this.storage});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDs.login(email: email, password: password);
      await storage.write(key: AppConstants.accessTokenKey, value: result.token);
      return result;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final result = await remoteDs.signup(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      await storage.write(key: AppConstants.accessTokenKey, value: result.token);
      return result;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      return await remoteDs.getMe();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<UserModel> updateMe(Map<String, dynamic> fields) async {
    try {
      return await remoteDs.updateMe(fields);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> deleteMe() async {
    try {
      await remoteDs.deleteMe();
      await storage.clearAll();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDs.logout();
    } catch (_) {
      // Always clear local state even if server call fails
    } finally {
      await storage.clearAll();
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await remoteDs.forgotPassword(email: email);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      return await remoteDs.verifyResetCode(email: email, code: code);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<AuthResponseModel> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final result = await remoteDs.resetPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      await storage.write(key: AppConstants.accessTokenKey, value: result.token);
      return result;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
