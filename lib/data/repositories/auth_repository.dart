import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// AuthRepository — مسئول عن جميع عمليات المصادقة (تسجيل، دخول، بروفايل...)
class AuthRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 👈 فلاغ للتحكم: شغّال بمود الـ Mock ولا بمود الـ API الحقيقي
  /// خليها true عشان تشتغل من غير سيرفر
  /// وخليها false لما تحب ترجع تستخدم الـ API
  static const bool useMockApi = true;

  /// 🔹 تسجيل الدخول
  Future<Response> login(String email, String password) async {
    // ✅ مود الـ Mock: من غير API نهائيًا
    if (useMockApi) {
      await Future.delayed(const Duration(seconds: 1)); // بس عشان تشوف الـ Loading

      // داتا وهمية كأنها جاية من السيرفر
      final fakeData = {
        "token": "mock_token_123",
        "user": {
          "_id": "1",
          "name": "Test User",
          "email": email,
        },
      };

      return Response(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        data: fakeData,
        statusCode: 200,
      );
    }

    // ✅ مود الـ API الحقيقي (الكود القديم زي ما هو)
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Login error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 إنشاء حساب جديد
  Future<Response> signup(String name, String email, String password) async {
    try {
      final response = await _client.post(
        ApiEndpoints.signup,
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Signup error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 إرسال رابط/كود نسيان كلمة المرور
  Future<Response> forgetPassword(String email) async {
    try {
      final response = await _client.post(
        ApiEndpoints.forgetPassword,
        data: {"email": email},
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Forget password error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 إعادة تعيين كلمة المرور
  /// في الـ API الجديد، لازم نضيف التوكن في نهاية الرابط
  Future<Response> resetPassword(String token, String newPassword, String confirmPassword) async {
    try {
      final url = "${ApiEndpoints.resetPassword}/$token";
      final response = await _client.patch(
        url,
        data: {
          "password": newPassword,
          "passwordConfirm": confirmPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Reset password error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 تحديث كلمة المرور أثناء تسجيل الدخول (updateMyPassword)
  Future<Response> updateMyPassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.updateMyPassword,
        data: {
          "passwordCurrent": currentPassword,
          "password": newPassword,
          "passwordConfirm": confirmPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Update password error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 جلب بيانات المستخدم (me)
  Future<Response> getMe() async {
    try {
      final response = await _client.get(ApiEndpoints.me);
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Get user error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 تحديث بيانات المستخدم (updateMe)
  Future<Response> updateMe(Map<String, dynamic> userData) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.updateMe,
        data: userData,
      );
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Update profile error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 حذف الحساب (deleteMe)
  Future<Response> deleteMe() async {
    try {
      final response = await _client.delete(ApiEndpoints.deleteMe);
      return response;
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Delete account error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🔹 تسجيل الخروج (محاكاة مؤقتة)
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // لاحقًا يمكن إضافة API endpoint حقيقي هنا إن وُجد
  }
}
