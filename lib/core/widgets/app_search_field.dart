import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../utils/extensions/context_ext.dart';
import '../utils/spacing.dart';

/// Reusable search field widget
/// Includes search icon, text input, and optional clear button
///
/// Usage:
///   AppSearchField(
///     hintText: 'Search flights...',
///     onChanged: (value) {},
///   )
///   AppSearchField(
///     hintText: 'Search',
///     controller: _controller,
///     onClear: () => _controller.clear(),
///   )
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.prefixIcon = Icons.search_rounded,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final IconData prefixIcon;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.font14Regular.copyWith(
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.font14Regular.copyWith(
          color: colors.textHint,
        ),
        filled: true,
        fillColor: colors.surface,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: rw(14),
          vertical: rh(12),
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: colors.iconSecondary,
          size: 20,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? GestureDetector(
                onTap: _clear,
                child: Icon(
                  Icons.close_rounded,
                  color: colors.iconSecondary,
                  size: 20,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.border),
          borderRadius: BorderRadius.circular(rr(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.border),
          borderRadius: BorderRadius.circular(rr(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary200, width: 1.5),
          borderRadius: BorderRadius.circular(rr(10)),
        ),
      ),
      onChanged: (value) {
        setState(() {}); // Rebuild to show/hide clear button
        widget.onChanged?.call(value);
      },
    );
  }
}
