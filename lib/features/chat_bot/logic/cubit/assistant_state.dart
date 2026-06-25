import 'package:equatable/equatable.dart';

import '../../../../core/shared/models/assistant_message.dart';

abstract class AssistantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssistantInitial extends AssistantState {}

class AssistantLoaded extends AssistantState {
  final List<AssistantMessage> messages;
  AssistantLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AssistantTyping extends AssistantState {
  final List<AssistantMessage> messages;
  AssistantTyping(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AssistantError extends AssistantState {
  final String message;
  AssistantError(this.message);

  @override
  List<Object?> get props => [message];
}
