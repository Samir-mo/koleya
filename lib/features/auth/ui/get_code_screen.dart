import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/auth/logic/cubit/verify_code_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/verify_code_state.dart';
import 'package:gate_buddy/features/auth/ui/reset_password_screen.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_header.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_primary_button.dart';

class GetCodeScreen extends StatelessWidget {
  final String email;

  const GetCodeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyCodeCubit(repo: getIt()),
      child: _GetCodeView(email: email),
    );
  }
}

class _GetCodeView extends StatefulWidget {
  final String email;
  const _GetCodeView({required this.email});

  @override
  State<_GetCodeView> createState() => _GetCodeViewState();
}

class _GetCodeViewState extends State<_GetCodeView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onVerify() {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.get_code.error'.tr()),
          backgroundColor: AppColors.amber200,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    context.read<VerifyCodeCubit>().verifyCode(
          email: widget.email,
          code: _code,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listener: (context, state) {
        if (state.status == VerifyCodeStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ResetPasswordScreen(resetToken: state.resetToken ?? ''),
            ),
          );
        } else if (state.status == VerifyCodeStatus.failure &&
            state.error != null) {
          _showError(context, state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: context.customColors.background,
        body: BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AuthHeader(
                    title: 'auth.get_code.title'.tr(),
                    subtitle: 'auth.get_code.subtitle'.tr(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(rw(24)),
                    child: Column(
                      children: [
                        verticalSpacing(8),
                        _CodeIllustration(),
                        verticalSpacing(24),
                        _EmailChip(email: widget.email),
                        verticalSpacing(32),
                        _OtpRow(
                          controllers: _controllers,
                          focusNodes: _focusNodes,
                        ),
                        verticalSpacing(12),
                        _ResendButton(email: widget.email),
                        verticalSpacing(32),
                        AuthPrimaryButton(
                          label: 'auth.get_code.button'.tr(),
                          isLoading: state.isLoading,
                          onPressed: _onVerify,
                        ),
                        verticalSpacing(24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red200,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _OtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const _OtpRow({required this.controllers, required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (i) => _OtpBox(
        controller: controllers[i],
        focusNode: focusNodes[i],
        onChanged: (v) {
          if (v.length == 1 && i < 5) {
            focusNodes[i + 1].requestFocus();
          } else if (v.isEmpty && i > 0) {
            focusNodes[i - 1].requestFocus();
          }
        },
      )),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return SizedBox(
      width: rw(48),
      height: rh(56),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: AppTextStyles.font20Bold.copyWith(color: AppColors.primary200),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: colors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary200, width: 2),
          ),
        ),
      ),
    );
  }
}

class _CodeIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          color: AppColors.primary50,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.password_rounded,
          size: 48,
          color: AppColors.primary200,
        ),
      ),
    );
  }
}

class _EmailChip extends StatelessWidget {
  final String email;
  const _EmailChip({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(10)),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(rr(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.email_outlined,
              size: 16, color: AppColors.primary200),
          SizedBox(width: rw(8)),
          Text(
            email,
            style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary200),
          ),
        ],
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  final String email;
  const _ResendButton({required this.email});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.get_code.resend_prompt'.tr(),
          style: AppTextStyles.font14Regular.copyWith(
              color: colors.textSecondary),
        ),
        GestureDetector(
          onTap: () {
            context.read<VerifyCodeCubit>().resendCode(email);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('auth.get_code.success'.tr()),
                backgroundColor: AppColors.green200,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Text(
            'auth.get_code.resend_link'.tr(),
            style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary200),
          ),
        ),
      ],
    );
  }
}
