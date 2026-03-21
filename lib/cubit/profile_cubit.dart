import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repo;
  ProfileCubit(this.repo) : super(ProfileInitial());

  /// تحميل بيانات المستخدم
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await repo.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  /// تحديث الملف الشخصي
  Future<void> updateProfile(String name, {String? imagePath}) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await repo.updateUserProfile(
        name: name,
        imagePath: imagePath,
      );
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}