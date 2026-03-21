import 'package:flutter_bloc/flutter_bloc.dart';
import 'logout_state.dart';
import 'package:koleya/data/repositories/auth_repository.dart';
import 'package:koleya/data/storage/auth_storage.dart';
import 'package:koleya/data/storage/current_user.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _repo = AuthRepository();

  /// Mock / API logout
  static const bool useMockLogout = true;

  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      // 🔹 لو API شغال بعدين
      if (!useMockLogout) {
        await _repo.logout();
      }

      // 🔹 مسح التخزين
      await AuthStorage.clearAuth();

      // ✅ مسح المستخدم الحالي من الذاكرة + تحديث UI
      CurrentUser.clear();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
