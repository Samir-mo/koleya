import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/data/base_remote_ds.dart';

import '../models/ai_chat_reply_model.dart';

class AssistantRemoteDs with BaseRemoteDs {
  final ApiConsumer api;

  AssistantRemoteDs({required this.api});

  Future<AssistantReplyModel> sendMessage(String message) => execute(() async {
    final response = await api.post(
      ApiEndpoints.assistant,
      body: {'message': message, 'context': {}},
    );
    final data = response['data'] as Map<String, dynamic>;
    return AssistantReplyModel.fromJson(data);
  });
}
