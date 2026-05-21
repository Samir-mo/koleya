import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/core/router/routes.dart';
import 'package:koleya/core/utils/extensions/context_ext.dart';
import 'package:koleya/cubit/login_cubit.dart';
import 'package:koleya/cubit/login_state.dart';

import '../../../../constants.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.pushNamedAndRemoveAll(Routes.mainScaffold);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return Stack(
              children: [
                _buildHeader(),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(Icons.email, "Email", controller: emailController),
                      const SizedBox(height: 20),
                      _buildTextField(
                        Icons.lock,
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
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      state is LoginLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildButton(
                              context,
                              "Log in",
                              onPressed: () {
                                cubit.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() => Stack(
    children: const [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 250,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(130)),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                "Gate buddy",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: -60,
        right: -60,
        child: CircleAvatar(backgroundColor: kAccentColor, radius: 80),
      ),
    ],
  );

  Widget _buildTextField(
    IconData icon,
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: kPrimaryColor),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kAccentColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: kAccentColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomText(BuildContext context, String text, String action, Widget screen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
          child: Text(
            action,
            style: const TextStyle(color: kAccentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
