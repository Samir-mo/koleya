import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> sendCode(String email) async {
    emit(ForgetPasswordLoading());
    try {
      // TODO: wire real API endpoint
      await Future.delayed(const Duration(seconds: 2));
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
