import 'storage_helper.dart';

class AuthStorage {
  static const _tokenKey = "access_token";
  static const _userKey = "user_data";

  // Local credentials
  static const _credEmailKey = "cred_email";
  static const _credPasswordKey = "cred_password";

  // ===== Token =====
  static Future<void> saveToken(String token) async =>
      await StorageHelper.save(_tokenKey, token);

  static String? getToken() {
    final token = StorageHelper.get(_tokenKey);
    return token?.toString();
  }

  // ===== User =====
  static Future<void> saveUser(Map<String, dynamic> user) async =>
      await StorageHelper.save(_userKey, user);

  static Map<String, dynamic>? getUser() {
    final data = StorageHelper.get(_userKey);
    return data is Map<String, dynamic> ? data : null;
  }

  // ===== Credentials (Local) =====
  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await StorageHelper.save(_credEmailKey, email);
    await StorageHelper.save(_credPasswordKey, password);
  }

  static Map<String, String?> getCredentials() {
    final e = StorageHelper.get(_credEmailKey);
    final p = StorageHelper.get(_credPasswordKey);

    final email = e?.toString();
    final password = p?.toString();

    return {
      "email": email,
      "password": password,
    };
  }

  static Future<void> clearAuth() async {
    await StorageHelper.remove(_tokenKey);
    await StorageHelper.remove(_userKey);
    await StorageHelper.remove(_credEmailKey);
    await StorageHelper.remove(_credPasswordKey);
  }
}
