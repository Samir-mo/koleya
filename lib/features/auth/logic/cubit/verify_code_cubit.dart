import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/auth_repo.dart';
import 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final AuthRepo repo;

  VerifyCodeCubit({required this.repo}) : super(const VerifyCodeState());

  Future<void> verifyCode({required String email, required String code}) async {
    emit(state.copyWith(status: VerifyCodeStatus.loading, clearError: true));
    try {
      final resetToken = await repo.verifyResetCode(email: email, code: code);
      emit(
        state.copyWith(
          status: VerifyCodeStatus.success,
          resetToken: resetToken,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: VerifyCodeStatus.failure, error: _message(e)),
      );
    }
  }

  Future<void> resendCode(String email) async {
    try {
      await repo.forgotPassword(email: email);
    } catch (_) {}
  }

  static String _message(Object e) {
    final s = e.toString();
    return s.startsWith('Exception:') ? s.replaceFirst('Exception: ', '') : s;
  }
}
