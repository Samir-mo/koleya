import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

import 'package:koleya/data/repositories/auth_repository.dart';
import 'package:koleya/data/storage/auth_storage.dart';
import 'package:koleya/data/models/user_model.dart';
import 'package:koleya/data/storage/current_user.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repo = AuthRepository();

  /// ✅ قبل ما تربط API خليه true (Local Login)
  /// ✅ لما تشغل API خليها false
  static const bool useMockLogin = true;

  LoginCubit() : super(LoginInitial());

  /// تسجيل الدخول
  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    // ================= LOCAL / MOCK MODE =================
    if (useMockLogin) {
      await Future.delayed(const Duration(milliseconds: 500));

      // 1) اقرأ بيانات الدخول اللي اتخزنت وقت الـ Sign Up
      final creds = AuthStorage.getCredentials();
      final savedEmail = creds["email"];
      final savedPassword = creds["password"];

      if (savedEmail == null || savedPassword == null) {
        emit(LoginFailure("مفيش حساب محفوظ.. اعمل Sign Up الأول"));
        return;
      }

      // 2) تحقق من الإيميل والباسورد
      if (email.trim() != savedEmail || password.trim() != savedPassword) {
        emit(LoginFailure("الإيميل أو كلمة المرور غلط"));
        return;
      }

      // 3) هات بيانات اليوزر (وفيها الاسم اللي اتكتب في Sign Up)
      final userMap = AuthStorage.getUser();
      final token = AuthStorage.getToken() ?? "local-token-$savedEmail";

      final storedName = (userMap?["name"] as String?) ?? "User";
      final storedEmail = (userMap?["email"] as String?) ?? savedEmail;
      final storedId = userMap?["id"]?.toString();
      final storedImage = userMap?["image"] as String?;

      // ✅ حدّث CurrentUser عشان صفحة البروفايل تعرض الاسم الحقيقي
      CurrentUser.setUser(
        id: storedId,
        name: storedName,
        email: storedEmail,
        image: storedImage,
        token: token,
      );

      emit(LoginSuccess(message: "Logged in locally ✅"));
      return;
    }

    // ================= REAL API MODE =================
    try {
      final response = await _repo.login(email, password);

      // الشكل المتوقع:
      // { "token": "...", "user": { ... } }
      final data = response.data;

      if (data == null || data["token"] == null || data["user"] == null) {
        emit(LoginFailure("Invalid response format"));
        return;
      }

      final String token = data["token"];
      final user = UserModel.fromJson(data["user"]);

      // حفظ في التخزين الدائم
      await AuthStorage.saveToken(token);
      await AuthStorage.saveUser(user.toJson());

      // تحديث CurrentUser
      CurrentUser.setUser(
        id: user.id.toString(),
        name: user.name,
        email: user.email ?? email,
        image: user.image,
        token: token,
      );

      emit(LoginSuccess(message: "Logged in successfully"));
    } catch (e) {
      emit(LoginFailure("Login failed: $e"));
    }
  }
}
