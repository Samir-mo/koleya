import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';

import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.pushNamedAndRemoveAll(Routes.mainScaffold);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("❌ ")));
          }
        },
        builder: (context, state) {
          context.read<AuthCubit>();

          return Stack(
            children: [
              _buildHeader(context),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: context.customColors.infoBackground,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      Icons.email,
                      context,
                      "Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      Icons.lock,
                      context,
                      "Password",
                      controller: passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.forgetPassword);
                        },
                        child: const Text(
                          "Forget password?",
                          style: AppTextStyles.font16Regular,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildButton(
                            context,
                            "Log in",
                            onPressed: () {
                              // cubit.login(
                              //   emailController.text.trim(),
                              //   passwordController.text.trim(),
                              // );
                            },
                          ),
                    const SizedBox(height: 20),
                    _buildBottomText(
                      context,
                      "You don't have an account? ",
                      "Sign",
                      SignupScreen(),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 16,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(context) => Stack(
    children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 250,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.customColors.infoBackground,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(130)),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                "Gate buddy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: -60,
        right: -60,
        child: CircleAvatar(
          backgroundColor: context.customColors.infoBackground,
          radius: 80,
        ),
      ),
    ],
  );

  Widget _buildTextField(
    IconData icon,
    context,
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: context.customColors.infoBackground),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.customColors.infoBackground),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.customColors.infoBackground),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label, {
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.customColors.infoBackground,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: AppTextStyles.font16Regular),
    );
  }

  Widget _buildBottomText(
    BuildContext context,
    String text,
    String action,
    Widget screen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
          child: Text(action, style: AppTextStyles.font16Regular),
        ),
      ],
    );
  }
}
