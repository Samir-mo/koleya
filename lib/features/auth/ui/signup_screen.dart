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
import 'package:gate_buddy/features/auth/ui/widgets/auth_primary_button.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSignup() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
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
          _showError(context, state.error!);
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
                    title: 'auth.signup.title'.tr(),
                    subtitle: 'auth.signup.subtitle'.tr(),
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
                            controller: _nameController,
                            label: 'auth.signup.full_name'.tr(),
                            hint: 'John Doe',
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (v) => Validators.minLength(v, 3,
                                fieldName: 'auth.signup.full_name'.tr()),
                          ),
                          verticalSpacing(16),
                          AuthTextField(
                            controller: _emailController,
                            label: 'auth.signup.email'.tr(),
                            hint: 'john@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          verticalSpacing(16),
                          AuthTextField(
                            controller: _passwordController,
                            label: 'auth.signup.password'.tr(),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: Validators.password,
                          ),
                          verticalSpacing(16),
                          AuthTextField(
                            controller: _confirmController,
                            label: 'auth.signup.confirm_password'.tr(),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSignup(),
                            validator: (v) => Validators.confirmPassword(
                                v, _passwordController.text),
                          ),
                          verticalSpacing(28),
                          AuthPrimaryButton(
                            label: 'auth.signup.button'.tr(),
                            isLoading: state.isLoading,
                            onPressed: _onSignup,
                          ),
                          verticalSpacing(24),
                          _buildLoginRow(context),
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

  Widget _buildLoginRow(BuildContext context) {
    final colors = context.customColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.signup.login_prompt'.tr(),
          style: AppTextStyles.font14Regular.copyWith(
              color: colors.textSecondary),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Text(
            'auth.signup.login_link'.tr(),
            style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary200),
          ),
        ),
      ],
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
