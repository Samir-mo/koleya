import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
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
          context.showErrorSnackBar(state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: context.customColors.background,
        body: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AuthHeader(
                    title: 'auth.forget_password.title'.tr(),
                    subtitle: 'auth.forget_password.subtitle'.tr(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(rw(24)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpacing(8),
                          _EnvelopeIllustration(),
                          verticalSpacing(32),
                          AuthTextField(
                            controller: _emailController,
                            label: 'auth.forget_password.email'.tr(),
                            hint: 'john@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSend(),
                            validator: Validators.email,
                          ),
                          verticalSpacing(28),
                          AuthPrimaryButton(
                            label: 'auth.forget_password.button'.tr(),
                            isLoading: state.isLoading,
                            onPressed: _onSend,
                          ),
                          verticalSpacing(24),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                'auth.forget_password.back'.tr(),
                                style: AppTextStyles.font14SemiBold.copyWith(
                                    color: AppColors.primary200),
                              ),
                            ),
                          ),
                          verticalSpacing(24),
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
