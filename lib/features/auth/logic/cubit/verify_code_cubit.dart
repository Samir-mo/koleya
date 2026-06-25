import 'package:flutter_bloc/flutter_bloc.dart';

import 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit() : super(VerifyCodeInitial());

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    emit(VerifyCodeLoading());
    try {
      // TODO: wire real API endpoint
      await Future.delayed(const Duration(seconds: 2));
      emit(VerifyCodeSuccess());
    } catch (e) {
      emit(VerifyCodeFailure(e.toString()));
    }
  }

  Future<void> resendCode(String email) async {
    try {
      // TODO: wire real API endpoint
      await Future.delayed(const Duration(seconds: 2));
    } catch (_) {}
  }
}
