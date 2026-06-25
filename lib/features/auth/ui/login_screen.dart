import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/validators.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_header.dart';
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
          _showError(context, state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Sign in to continue your journey',
                    showBack: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          AuthTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'john@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            controller: _passwordController,
                            label: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onLogin(),
                            validator: (v) =>
                                Validators.required(v, fieldName: 'Password'),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, Routes.forgetPassword),
                              child: Text(
                                'Forgot password?',
                                style: AppTextStyles.font14SemiBold.copyWith(
                                    color: AppColors.primary200),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthPrimaryButton(
                            label: 'Log In',
                            isLoading: state.isLoading,
                            onPressed: _onLogin,
                          ),
                          const SizedBox(height: 28),
                          _buildDivider(),
                          const SizedBox(height: 28),
                          _buildSignupRow(context),
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.grey100)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style:
                AppTextStyles.font12Regular.copyWith(color: AppColors.grey400),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey100)),
      ],
    );
  }

  Widget _buildSignupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style:
              AppTextStyles.font14Regular.copyWith(color: AppColors.grey500),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.signup),
          child: Text(
            'Sign Up',
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
