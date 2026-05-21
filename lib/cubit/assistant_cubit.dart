import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/assistant_repository.dart';
import '../core/shared/models/assistant_message.dart';
import 'assistant_state.dart';

class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepository _repo = AssistantRepository();
  final List<AssistantMessage> _messages = [];

  AssistantCubit() : super(AssistantInitial());

  List<AssistantMessage> get messages => _messages;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // إضافة رسالة المستخدم
    _messages.add(AssistantMessage(sender: "user", text: text));
    emit(AssistantLoaded(List.from(_messages)));

    try {
      emit(AssistantLoading());

      final response = await _repo.sendMessage(text);
      _messages.add(AssistantMessage(sender: "bot", text: response.reply));

      emit(AssistantLoaded(List.from(_messages)));
    } catch (e) {
      _messages.add(AssistantMessage(
          sender: "bot", text: "❌ Failed to connect. Please try again."));
      emit(AssistantError(e.toString()));
      emit(AssistantLoaded(List.from(_messages)));
    }
  }
}