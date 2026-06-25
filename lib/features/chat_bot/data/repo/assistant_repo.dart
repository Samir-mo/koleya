import '../models/assistant_reply_model.dart';

abstract class AssistantRepo {
  Future<AssistantReplyModel> sendMessage(String message);
}
