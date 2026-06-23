import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit({required this.repo}) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final response = await repo.login(email, password);

      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final response = await repo.signup(name, email, password);

      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(AuthLoading());

    try {
      final response = await repo.forgetPassword(email);

      emit(AuthMessage(response.data["message"] ?? "Reset email sent"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());

    try {
      final response = await repo.resetPassword(
        token,
        password,
        passwordConfirm,
      );

      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateMyPassword({
    required String currentPassword,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());

    try {
      final response = await repo.updateMyPassword(
        currentPassword,
        password,
        passwordConfirm,
      );

      emit(AuthMessage(response.data["message"] ?? "Password updated"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> getMe() async {
    emit(AuthLoading());

    try {
      final response = await repo.getMe();

      emit(AuthUserLoaded(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateMe(Map<String, dynamic> data) async {
    emit(AuthLoading());

    try {
      final response = await repo.updateMe(data);

      emit(AuthSuccess(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> deleteMe() async {
    emit(AuthLoading());

    try {
      await repo.deleteMe();

      emit(const AuthMessage("Account deleted"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await repo.logout();

    emit(AuthInitial());
  }
}
