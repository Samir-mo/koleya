import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  Future<void> loadProfile() async {}
  Future<void> updateProfile(Map<String, dynamic> data) async {}
  Future<void> changePassword(Map<String, dynamic> data) async {}
  Future<void> deleteAccount() async {}
}
