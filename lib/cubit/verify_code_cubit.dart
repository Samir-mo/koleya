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
      // 📌 TODO: هنا هتحط اتصال الـ API بتاع التحقق
      // final response = await Dio().post("YOUR_ENDPOINT", data: {...});
      await Future.delayed(const Duration(seconds: 2)); // تنفيذ مؤقت

      emit(VerifyCodeSuccess());
    } catch (e) {
      emit(VerifyCodeFailure(e.toString()));
    }
  }

  Future<void> resendCode(String email) async {
    try {
      // 📌 TODO: هنا API لإعادة إرسال الكود للمستخدم
      await Future.delayed(const Duration(seconds: 2));
    } catch (_) {
      // ممكن تضيف استيت تانية لو عايز تعرض لودينج للإرسال كمان
    }
  }
}