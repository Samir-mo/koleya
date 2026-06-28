import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/auth_repo.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepo repo;

  ForgetPasswordCubit({required this.repo})
      : super(const ForgetPasswordState());

  Future<void> sendCode(String email) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading, clearError: true));
    try {
      await repo.forgotPassword(email: email);
      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ForgetPasswordStatus.failure, error: _message(e)));
    }
  }

  static String _message(Object e) {
    final s = e.toString();
    return s.startsWith('Exception:') ? s.replaceFirst('Exception: ', '') : s;
  }
}
