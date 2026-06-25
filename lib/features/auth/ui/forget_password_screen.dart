import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/validators.dart';
import 'package:gate_buddy/features/auth/logic/cubit/forget_password_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/forget_password_state.dart';
import 'package:gate_buddy/features/auth/ui/get_code_screen.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_header.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_primary_button.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(repo: getIt()),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (!_formKey.currentState!.validate()) return;
    context
        .read<ForgetPasswordCubit>()
        .sendCode(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.status == ForgetPasswordStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ForgetPasswordCubit>(),
                child: GetCodeScreen(email: _emailController.text.trim()),
              ),
            ),
          );
        } else if (state.status == ForgetPasswordStatus.failure &&
            state.error != null) {
          _showError(context, state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Forgot Password?',
                    subtitle: "Enter your email and we'll send a reset code",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _EnvelopeIllustration(),
                          const SizedBox(height: 32),
                          AuthTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'john@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSend(),
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 28),
                          AuthPrimaryButton(
                            label: 'Send Reset Code',
                            isLoading: state.isLoading,
                            onPressed: _onSend,
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Back to Login',
                                style: AppTextStyles.font14SemiBold.copyWith(
                                    color: AppColors.primary200),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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

class _EnvelopeIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mark_email_unread_outlined,
          size: 48,
          color: AppColors.primary200,
        ),
      ),
    );
  }
}
