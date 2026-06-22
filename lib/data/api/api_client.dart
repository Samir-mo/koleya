import 'package:dio/dio.dart';
import 'package:gate_buddy/data/storage/auth_storage.dart'; // ✅ لإضافة التوكن تلقائيًا

/// ApiClient — إعداد الاتصال العام بالتطبيق
class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  // ✅ إعداد Dio الأساسي
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://gate-buddy-backend-production-f6df.up.railway.app/api/v1",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  );

  Dio get dio => _dio;

  /// 🔧 إعداد الـ Interceptors (تضاف في main.dart بـ ApiClient.setupInterceptors())
  static void setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🧩 إضافة الـ Token إن وُجد
          final token = AuthStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          print(
            "🌐 Request → [${options.method}] ${options.baseUrl}${options.path}",
          );
          return handler.next(options);
        },

        onResponse: (response, handler) {
          print(
            "✅ Response [${response.statusCode}] → ${response.requestOptions.path}",
          );
          return handler.next(response);
        },

        onError: (DioException e, handler) {
          final status = e.response?.statusCode;
          final message = e.response?.data?['message'] ?? e.message;
          print("❌ API Error ($status): $message");
          return handler.next(e);
        },
      ),
    );
  }

  /// ✅ دوال عامة للنداء على الـ API
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    return await _dio.delete(path, data: data);
  }
}
