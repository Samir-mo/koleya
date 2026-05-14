import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';
import 'package:koleya/data/repositories/auth_repository.dart';
import 'package:koleya/data/storage/auth_storage.dart';
import 'package:koleya/core/shared/models/user_model.dart';
import 'package:koleya/data/storage/current_user.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _repo = AuthRepository();

  /// ✅ قبل API خليه true
  /// ✅ لما تشغل API خليها false (بس هيفضل يحفظ credentials بعد النجاح)
  static const bool useMockSignup = true;

  SignupCubit() : super(SignupInitial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());

    // ================= MOCK MODE =================
    if (useMockSignup) {
      await Future.delayed(const Duration(milliseconds: 600));

      // ✅ احفظ credentials (عشان Login يلاقي الحساب)
      await AuthStorage.saveCredentials(email: email, password: password);

      // ✅ احفظ user + token محليًا
      final token = "local-token-$email";
      final userMap = <String, dynamic>{
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": name,
        "email": email,
        "image": null,
      };

      await AuthStorage.saveToken(token);
      await AuthStorage.saveUser(userMap);

      // ✅ حدّث CurrentUser (اختياري)
      CurrentUser.setUser(
        id: userMap["id"].toString(),
        name: name,
        email: email,
        image: null,
        token: token,
      );

      // ✅ Debug (شيلهم بعدين لو تحب)
      print("CREDS AFTER SIGNUP => ${AuthStorage.getCredentials()}");
      print("USER  AFTER SIGNUP => ${AuthStorage.getUser()}");

      emit(SignupSuccess(message: "Account created locally ✅"));
      return;
    }

    // ================= REAL API MODE =================
    try {
      final response = await _repo.signup(name, email, password);

      final data = response.data;
      if (data == null || data["token"] == null || data["user"] == null) {
        emit(SignupFailure("Invalid response format"));
        return;
      }

      final token = data["token"];
      final user = UserModel.fromJson(data["user"]);

      await AuthStorage.saveToken(token);
      await AuthStorage.saveUser(user.toJson());

      // ✅ مهم: حتى في API mode، خزّن credentials للتجربة المحلية
      await AuthStorage.saveCredentials(email: email, password: password);

      CurrentUser.setUser(
        id: user.id.toString(),
        name: user.name,
        email: user.email ?? email,
        image: user.image,
        token: token,
      );

      print("CREDS AFTER SIGNUP(API) => ${AuthStorage.getCredentials()}");
      print("USER  AFTER SIGNUP(API) => ${AuthStorage.getUser()}");

      emit(SignupSuccess(message: "Account created successfully"));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
