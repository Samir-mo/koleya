import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/utils/validators.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_header.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_primary_button.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String resetToken;

  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: _ResetPasswordView(resetToken: resetToken),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  final String resetToken;
  const _ResetPasswordView({required this.resetToken});

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
          resetToken: widget.resetToken,
          password: _passwordController.text,
          passwordConfirm: _confirmController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.pushNamedAndRemoveAll(Routes.mainScaffold);
        } else if (state.status == AuthStatus.error && state.error != null) {
          context.showErrorSnackBar(state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: context.customColors.background,
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AuthHeader(
                    title: 'auth.reset_password.title'.tr(),
                    subtitle: 'auth.reset_password.subtitle'.tr(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(rw(24)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          verticalSpacing(8),
                          _LockIllustration(),
                          verticalSpacing(32),
                          AuthTextField(
                            controller: _passwordController,
                            label: 'auth.reset_password.new_password'.tr(),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: Validators.password,
                          ),
                          verticalSpacing(16),
                          AuthTextField(
                            controller: _confirmController,
                            label: 'auth.reset_password.confirm_password'.tr(),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onReset(),
                            validator: (v) => Validators.confirmPassword(
                                v, _passwordController.text),
                          ),
                          verticalSpacing(28),
                          AuthPrimaryButton(
                            label: 'auth.reset_password.button'.tr(),
                            isLoading: state.isLoading,
                            onPressed: _onReset,
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

class _LockIllustration extends StatelessWidget {
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
          Icons.lock_reset_rounded,
          size: 48,
          color: AppColors.primary200,
        ),
      ),
    );
  }
}
