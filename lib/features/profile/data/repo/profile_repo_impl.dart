import '../../../../core/errors/error_handler.dart';
import '../remote/profile_remote_ds.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDs remoteDs;
  ProfileRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getMe() async {
    try {
      return await remoteDs.getMe();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> updateMe(Map<String, dynamic> data) async {
    try {
      return await remoteDs.updateMe(data);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> updateMyPassword(Map<String, dynamic> data) async {
    try {
      return await remoteDs.updateMyPassword(data);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<dynamic> deleteMe() async {
    try {
      return await remoteDs.deleteMe();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
