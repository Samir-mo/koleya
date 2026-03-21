import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

/// AssistantRepository — مسئول عن التواصل مع مسار الذكاء الاصطناعي (Chatbot)
class AssistantRepository {
  final Dio _client = ApiClient.instance.dio;

  /// 🔹 إرسال رسالة إلى الـ Assistant واستقبال الرد
  Future<AssistantReply> sendMessage(String message) async {
    try {
      final response = await _client.post(
        ApiEndpoints.assistant,
        data: {"message": message},
      );

      // تأكد من أن الاستجابة فيها reply
      return AssistantReply.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Assistant API error";
      throw Exception(msg);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}

/// نموذج الرد القادم من السيرفر
class AssistantReply {
  final String reply;

  AssistantReply({required this.reply});

  factory AssistantReply.fromJson(Map<String, dynamic> json) {
    return AssistantReply(
      reply: json["reply"] ?? "🤖 No reply received from assistant.",
    );
  }

  Map<String, dynamic> toJson() => {"reply": reply};
}