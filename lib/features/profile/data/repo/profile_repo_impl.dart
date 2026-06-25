import 'package:gate_buddy/features/profile/data/remote/profile_remote_ds.dart';
import 'package:gate_buddy/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDs remoteDs;
  ProfileRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getMe() => remoteDs.getMe();

  @override
  Future<dynamic> updateMe(Map<String, dynamic> data) =>
      remoteDs.updateMe(data);

  @override
  Future<dynamic> updateMyPassword(Map<String, dynamic> data) =>
      remoteDs.updateMyPassword(data);

  @override
  Future<dynamic> deleteMe() => remoteDs.deleteMe();
}
