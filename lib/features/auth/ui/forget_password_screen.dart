import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/core/themes/app_text_styles.dart';
import 'package:koleya/core/utils/extensions/context_ext.dart';
import 'package:koleya/cubit/forget_password_cubit.dart';
import 'package:koleya/cubit/forget_password_state.dart';

import '../../../ui/screens/get_code_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => ForgetPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GetCodeScreen(email: emailController.text.trim()),
                ),
              );
            } else if (state is ForgetPasswordFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<ForgetPasswordCubit>();

            return Stack(
              children: [
                // 🔹 الخلفية الزرقاء
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

                // 🔸 الدائرة الذهبية
                Positioned(
                  top: -60,
                  right: -60,
                  child: CircleAvatar(
                    backgroundColor: context.customColors.infoBackground,
                    radius: 80,
                  ),
                ),

                // 🔙 زر الرجوع
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

                // 🔹 محتوى الصفحة
                Positioned.fill(
                  top: height * 0.30,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Forget password",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.customColors.infoBackground,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: context.customColors.infoBackground,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.customColors.infoBackground,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.customColors.infoBackground,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        state is ForgetPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () {
                                  final email = emailController.text.trim();

                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter your email.",
                                        ),
                                      ),
                                    );
                                    return;
                                  } else if (!_isValidEmail(email)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter a valid email address.",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  cubit.sendCode(email);
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
                                  "Next",
                                  style: AppTextStyles.font18Light,
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
}
