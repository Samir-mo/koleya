import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';

class InputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final dynamic colors;

  const InputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.colors,
  });

  @override
  State<InputBar> createState() => InputBarState();
}

class InputBarState extends State<InputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.only(
        left: rw(16),
        right: rw(16),
        top: rh(10),
        bottom: MediaQuery.of(context).padding.bottom + rh(10),
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(rr(24)),
                border: Border.all(color: colors.border),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: AppTextStyles.font14Regular.copyWith(
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'ai_chat.input_hint'.tr(),
                  hintStyle: AppTextStyles.font14Regular.copyWith(
                    color: colors.textHint,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: rw(16),
                    vertical: rh(10),
                  ),
                  filled: false,
                ),
              ),
            ),
          ),
          horizontalSpacing(10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: rw(44),
            height: rw(44),
            decoration: BoxDecoration(
              color: _hasText ? AppColors.primary200 : colors.border,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _hasText ? widget.onSend : null,
              icon: Icon(Icons.send_rounded, size: rr(20)),
              color: AppColors.white,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
