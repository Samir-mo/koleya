import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/assistant_app_bar.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/input_bar.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/message_bubble.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/typing_indicator.dart';

import '../logic/cubit/ai_chat_cubit.dart';
import '../logic/cubit/ai_chat_state.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) => const _AssistantView();
}

class _AssistantView extends StatefulWidget {
  const _AssistantView();

  @override
  State<_AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<_AssistantView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    context.read<AssistantCubit>().sendMessage(text);
    _inputController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Column(
      children: [
        AssistantAppBar(),
        Expanded(
          child: BlocConsumer<AssistantCubit, AssistantState>(
            listener: (context, state) {
              if (state is AssistantLoaded || state is AssistantTyping) {
                _scrollToBottom();
              }
            },
            builder: (context, state) {
              final messages = switch (state) {
                AssistantLoaded s => s.messages,
                AssistantTyping s => s.messages,
                _ => context.read<AssistantCubit>().messages,
              };
              final isTyping = state is AssistantTyping;

              if (messages.isEmpty) {
                return _EmptyState(colors: colors);
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return const TypingIndicator();
                  }
                  return MessageBubble(
                    message: messages[index],
                    colors: colors,
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: InputBar(
            controller: _inputController,
            focusNode: _focusNode,
            onSend: _send,
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final dynamic colors;

  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.primary200,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Hi! I\'m GateBuddy ✈️',
            style: AppTextStyles.font18Bold.copyWith(
              color: AppColors.primary200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your flight,\ngate, or airport services.',
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Regular.copyWith(
              color: colors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
