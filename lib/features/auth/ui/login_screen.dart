import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/utils/validators.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_header.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_primary_button.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
            final colors = context.customColors;
            return SingleChildScrollView(
              child: Column(
                children: [
                  AuthHeader(
                    title: 'auth.login.title'.tr(),
                    subtitle: 'auth.login.subtitle'.tr(),
                    showBack: false,
                  ),
                  Padding(
                    padding: EdgeInsets.all(rw(24)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpacing(8),
                          AuthTextField(
                            controller: _emailController,
                            label: 'auth.login.email'.tr(),
                            hint: 'john@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          verticalSpacing(16),
                          AuthTextField(
                            controller: _passwordController,
                            label: 'auth.login.password'.tr(),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onLogin(),
                            validator: (v) =>
                                Validators.required(v, fieldName: 'auth.login.password'.tr()),
                          ),
                          verticalSpacing(4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomTextButton.text(
                              text: 'auth.login.forgot_password'.tr(),
                              onPressed: () => context.pushNamed(Routes.forgetPassword),
                              isFullWidth: false,
                            ),
                          ),
                          verticalSpacing(8),
                          AuthPrimaryButton(
                            label: 'auth.login.button'.tr(),
                            isLoading: state.isLoading,
                            onPressed: _onLogin,
                          ),
                          verticalSpacing(28),
                          _buildDivider(colors),
                          verticalSpacing(28),
                          _buildSignupRow(context, colors),
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

  Widget _buildDivider(dynamic colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(12)),
          child: Text(
            'auth.login.divider'.tr(),
            style: AppTextStyles.font12Regular.copyWith(
                color: colors.textHint),
          ),
        ),
        Expanded(child: Divider(color: colors.divider)),
      ],
    );
  }

  Widget _buildSignupRow(BuildContext context, dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.login.signup_prompt'.tr(),
          style: AppTextStyles.font14Regular.copyWith(
              color: colors.textSecondary),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(Routes.signup),
          child: Text(
            'auth.login.signup_link'.tr(),
            style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary200),
          ),
        ),
      ],
    );
  }

}
