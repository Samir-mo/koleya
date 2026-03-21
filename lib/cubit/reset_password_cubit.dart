import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      // 📌 TODO: هنا توصل بالـ API الحقيقي لتغيير كلمة المرور
      // ممكن تبعت الـ email والكود لو الـ API بيحتاجهم
      await Future.delayed(const Duration(seconds: 2)); // simulation

      // لو الكلمة تمام
      emit(ResetPasswordSuccess());

      // أو لو فشل:
      // emit(ResetPasswordFailure("Passwords do not match or invalid"));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}