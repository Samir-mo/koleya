import '../models/assistant_reply_model.dart';
import '../remote/assistant_remote_ds.dart';
import 'assistant_repo.dart';

class AssistantRepoImpl implements AssistantRepo {
  final AssistantRemoteDs remoteDs;

  AssistantRepoImpl({required this.remoteDs});

  @override
  Future<AssistantReplyModel> sendMessage(String message) {
    return remoteDs.sendMessage(message);
  }
}
