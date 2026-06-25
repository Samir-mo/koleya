abstract class ProfileRepo {
  Future<dynamic> getMe();
  Future<dynamic> updateMe(Map<String, dynamic> data);
  Future<dynamic> updateMyPassword(Map<String, dynamic> data);
  Future<dynamic> deleteMe();
}
