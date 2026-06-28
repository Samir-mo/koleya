import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/errors/failure.dart';

import '../../../../core/shared/models/assistant_message.dart';
import '../../data/repo/ai_chat_repo.dart';
import 'ai_chat_state.dart';

class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepo repo;
  final List<AssistantMessage> _messages = [];

  AssistantCubit({required this.repo}) : super(AssistantInitial());

  List<AssistantMessage> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _messages.add(AssistantMessage(sender: 'user', text: trimmed));
    emit(AssistantLoaded(List.from(_messages)));
    emit(AssistantTyping(List.from(_messages)));

    try {
      final reply = await repo.sendMessage(trimmed);
      _messages.add(AssistantMessage(sender: 'bot', text: reply.reply));
      emit(AssistantLoaded(List.from(_messages)));
    } catch (e) {
      final msg = e is Failure ? e.message : 'Something went wrong. Try again.';
      _messages.add(AssistantMessage(sender: 'bot', text: msg));
      emit(AssistantLoaded(List.from(_messages)));
    }
  }
}
