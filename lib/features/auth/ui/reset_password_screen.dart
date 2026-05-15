import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/core/utils/extensions/context_ext.dart';
import 'package:koleya/cubit/reset_password_cubit.dart';
import 'package:koleya/cubit/reset_password_state.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _showMessage(BuildContext context, String msg, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              _showMessage(context, state.message, error: false);

              // يتم نقل المستخدم إلى شاشة تسجيل الدخول بعد نجاح العملية
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              });
            } else if (state is ResetPasswordFailure) {
              _showMessage(context, state.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ResetPasswordCubit>();

            return Stack(
              children: [
                // الجزء العلوي
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * 0.33,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.customColors.infoBackground,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(130),
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
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

                // الدائرة الذهبية
                Positioned(
                  top: -60,
                  right: -60,
                  child: CircleAvatar(
                    backgroundColor: context.customColors.infoBackground,
                    radius: 80,
                  ),
                ),

                // زر الرجوع
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

                // المحتوى القابل للتمرير
                Positioned.fill(
                  top: height * 0.30,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Reset password",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.customColors.infoBackground,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // الحقول
                        _buildPasswordField(
                          context,
                          controller: newPasswordController,
                          hint: "Enter new password",
                        ),
                        const SizedBox(height: 20),
                        _buildPasswordField(
                          context,
                          controller: confirmPasswordController,
                          hint: "Confirm password",
                        ),
                        const SizedBox(height: 30),

                        // الزر
                        state is ResetPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () {
                                  final newPass = newPasswordController.text
                                      .trim();
                                  final confirmPass = confirmPasswordController
                                      .text
                                      .trim();

                                  if (newPass.isEmpty || confirmPass.isEmpty) {
                                    _showMessage(
                                      context,
                                      "Please fill in both fields.",
                                    );
                                    return;
                                  }
                                  if (newPass.length < 6) {
                                    _showMessage(
                                      context,
                                      "Password must be at least 6 characters.",
                                    );
                                    return;
                                  }
                                  if (newPass != confirmPass) {
                                    _showMessage(
                                      context,
                                      "Passwords do not match.",
                                    );
                                    return;
                                  }

                                  cubit.resetPassword(
                                    newPassword: newPass,
                                    confirmPassword: confirmPass,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      context.customColors.infoBackground,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: context.customColors.infoBackground,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                      ],
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

  Widget _buildPasswordField(
    context, {
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.lock,
          color: context.customColors.infoBackground,
        ),
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
}
