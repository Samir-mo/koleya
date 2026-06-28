import 'package:gate_buddy/core/errors/error_handler.dart';

import '../models/ai_chat_reply_model.dart';
import '../remote/ai_chat_remote_ds.dart';
import 'ai_chat_repo.dart';

class AssistantRepoImpl implements AssistantRepo {
  final AssistantRemoteDs remoteDs;

  AssistantRepoImpl({required this.remoteDs});

  @override
  Future<AssistantReplyModel> sendMessage(String message) async {
    try {
      return await remoteDs.sendMessage(message);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
