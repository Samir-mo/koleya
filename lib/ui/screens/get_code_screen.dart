import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/cubit/verify_code_cubit.dart';
import 'package:koleya/cubit/verify_code_state.dart';
import '../../../constants.dart';
import 'package:koleya/routes/app_routes.dart';
class GetCodeScreen extends StatelessWidget {
  final String? email;
  GetCodeScreen({super.key, this.email});

  final TextEditingController codeController = TextEditingController();

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
      create: (_) => VerifyCodeCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
          listener: (context, state) {
            if (state is VerifyCodeSuccess) {
              _showMessage(context, state.message, error: false);
              Navigator.pushNamed(
                context,
                Routes.resetPassword,
              );
            } else if (state is VerifyCodeFailure) {
              _showMessage(context, state.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<VerifyCodeCubit>();

            return Stack(
              children: [
                // 🔹 الخلفية الزرقاء
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * 0.33,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(130)),
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
                const Positioned(
                  top: -60,
                  right: -60,
                  child:
                      CircleAvatar(backgroundColor: kAccentColor, radius: 80),
                ),

                // 🔙 زر الرجوع
                Positioned(
                  top: 50,
                  left: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // 🔹 المحتوى القابل للتمرير
                Positioned.fill(
                  top: height * 0.30,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Get your code",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // حقل إدخال الكود
                        TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter your code",
                            prefixIcon: const Icon(
                              Icons.confirmation_number,
                              color: kPrimaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: kAccentColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              cubit.resendCode(email ?? "");
                              _showMessage(
                                context,
                                "Verification code resent ✅",
                                error: false,
                              );
                            },
                            child: const Text(
                              "Resend code?",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        state is VerifyCodeLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  final code = codeController.text.trim();

                                  if (code.isEmpty) {
                                    _showMessage(context,
                                        "Please enter the verification code.");
                                    return;
                                  } else if (code.length < 4) {
                                    _showMessage(context,
                                        "Invalid code. Please check and try again.");
                                    return;
                                  }

                                  cubit.verifyCode(
                                    email: email ?? "",
                                    code: code,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  minimumSize:
                                      const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                        const SizedBox(height: 40),
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