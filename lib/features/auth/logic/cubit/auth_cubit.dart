import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';

import '../../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit({required this.repo}) : super(const AuthState());

  /// Called once at app start — validates stored token against the server.
  /// Emits [authenticated] if token is valid, [unauthenticated] otherwise.
  Future<void> checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repo.getMe();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final result = await repo.login(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: result.user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _message(e),
          clearUser: true,
        ),
      );
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final result = await repo.signup(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: result.user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _message(e),
          clearUser: true,
        ),
      );
    }
  }

  Future<void> getMe() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await repo.getMe();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: _message(e)));
    }
  }

  Future<void> updateMe(Map<String, dynamic> fields) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await repo.updateMe(fields);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: _message(e)));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await repo.logout();
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
    );
  }

  Future<void> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final result = await repo.resetPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: result.user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: _message(e),
          clearUser: true,
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await repo.deleteMe();
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: _message(e)));
    }
  }

  static String _message(Object e) {
    if (e is Failure) return e.message;
    final s = e.toString();
    if (s.startsWith('Exception:')) return s.replaceFirst('Exception: ', '');
    return s;
  }
}
