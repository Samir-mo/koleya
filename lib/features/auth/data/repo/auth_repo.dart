abstract class AuthRepo {
  Future<dynamic> login(String email, String password);

  Future<dynamic> signup(String name, String email, String password);

  Future<dynamic> forgetPassword(String email);

  Future<dynamic> resetPassword(
    String token,
    String password,
    String passwordConfirm,
  );

  Future<dynamic> updateMyPassword(
    String currentPassword,
    String password,
    String passwordConfirm,
  );

  Future<dynamic> getMe();

  Future<dynamic> updateMe(Map<String, dynamic> userData);

  Future<dynamic> deleteMe();

  Future<void> logout();
}
