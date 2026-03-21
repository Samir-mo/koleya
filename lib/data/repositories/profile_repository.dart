import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/user_model.dart';

/// ProfileRepository — مسئول عن البيانات الشخصية للمستخدم
class ProfileRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 📥 جلب بيانات المستخدم (GET /auth/me)
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _client.get(ApiEndpoints.me);
      return UserModel.fromJson(response.data["data"] ?? response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Get profile error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 📤 تحديث بيانات المستخدم (PATCH /auth/updateMe)
  /// يدعم تعديل الاسم والصورة
  Future<UserModel> updateUserProfile({
    required String name,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        if (imagePath != null)
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
      });

      final response = await _client.patch(
        ApiEndpoints.updateMe,
        data: formData,
      );

      return UserModel.fromJson(response.data["data"] ?? response.data);
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Update profile error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  /// 🗑️ حذف الحساب (DELETE /auth/deleteMe)
  Future<bool> deleteAccount() async {
    try {
      final response = await _client.delete(ApiEndpoints.deleteMe);
      return response.statusCode == 204 || response.statusCode == 200;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ?? e.message ?? "Delete account error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}