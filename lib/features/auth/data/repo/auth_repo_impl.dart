import 'package:dio/dio.dart';
import 'package:gate_buddy/features/auth/data/remote/auth_remote_ds.dart';

import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDs remote;

  const AuthRepoImpl({required this.remote});

  @override
  Future<Response> login(String email, String password) async {
    try {
      return await remote.login(email: email, password: password);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? e.message ?? "Login failed",
      );
    }
  }

  @override
  Future<Response> signup(String name, String email, String password) async {
    try {
      return await remote.signup(name: name, email: email, password: password);
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> forgetPassword(String email) async {
    try {
      return await remote.forgetPassword(email: email);
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> resetPassword(
    String token,
    String password,
    String passwordConfirm,
  ) async {
    try {
      return await remote.resetPassword(
        token: token,
        password: password,
        passwordConfirm: passwordConfirm,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> updateMyPassword(
    String currentPassword,
    String password,
    String passwordConfirm,
  ) async {
    try {
      return await remote.updateMyPassword(
        currentPassword: currentPassword,
        password: password,
        passwordConfirm: passwordConfirm,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> getMe() async {
    try {
      return await remote.getMe();
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> updateMe(Map<String, dynamic> userData) async {
    try {
      return await remote.updateMe(userData);
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<Response> deleteMe() async {
    try {
      return await remote.deleteMe();
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? e.message);
    }
  }

  @override
  Future<void> logout() async {}
}
