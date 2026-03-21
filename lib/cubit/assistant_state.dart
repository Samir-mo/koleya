import 'package:equatable/equatable.dart';
import '../../data/models/assistant_message.dart';

abstract class AssistantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssistantInitial extends AssistantState {}

class AssistantLoading extends AssistantState {}

class AssistantLoaded extends AssistantState {
  final List<AssistantMessage> messages;
  AssistantLoaded(this.messages); // ← بدون const

  @override
  List<Object?> get props => [messages];
}

class AssistantError extends AssistantState {
  final String message;
  AssistantError(this.message); // ← بدون const

  @override
  List<Object?> get props => [message];
}