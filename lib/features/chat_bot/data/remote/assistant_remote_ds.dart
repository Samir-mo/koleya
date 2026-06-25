import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/assistant_reply_model.dart';

class AssistantRemoteDs {
  final ApiConsumer api;

  AssistantRemoteDs({required this.api});

  Future<AssistantReplyModel> sendMessage(String message) async {
    try {
      final response = await api.post(
        ApiEndpoints.assistant,
        body: {
          'message': message,
          'context': {},
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return AssistantReplyModel.fromJson(data);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
