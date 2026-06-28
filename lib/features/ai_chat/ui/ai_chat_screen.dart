import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/assistant_app_bar.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/input_bar.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/message_bubble.dart';
import 'package:gate_buddy/features/ai_chat/ui/widgets/typing_indicator.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';

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

  bool get _isAuthenticated =>
      context.read<AuthCubit>().state.isAuthenticated;

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    if (!_isAuthenticated) {
      _showLoginPrompt();
      return;
    }

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

  void _showLoginPrompt() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rr(16))),
        title: Text('ai_chat.login_required'.tr()),
        content: Text(
          'ai_chat.login_required_message'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.login);
            },
            child: Text(
              'Log In',
              style: AppTextStyles.font14SemiBold.copyWith(
                  color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Column(
      children: [
        AssistantAppBar(),
        // Auth guard banner — visible only when not logged in
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) =>
              prev.isAuthenticated != curr.isAuthenticated,
          builder: (context, authState) {
            if (authState.isAuthenticated) return const SizedBox.shrink();
            return _AuthBanner();
          },
        ),
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

// ── Auth banner shown when unauthenticated ────────────────────────────────────

class _AuthBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.amber0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 16, color: AppColors.amber300),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Log in to chat with GateBuddy',
              style: AppTextStyles.font12Regular.copyWith(
                  color: AppColors.amber400),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.login),
            child: Text(
              'Log In',
              style: AppTextStyles.font12Medium.copyWith(
                  color: AppColors.amber400),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

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
