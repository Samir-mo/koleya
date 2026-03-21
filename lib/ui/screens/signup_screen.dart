import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/ui/screens/login_screen.dart';
import '../../../constants.dart';

import 'package:koleya/cubit/signup_cubit.dart';
import 'package:koleya/cubit/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ من فضلك املا كل الحقول")),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ كلمة المرور وتأكيدها مش متطابقين")),
      );
      return;
    }

    context.read<SignupCubit>().signup(
          name: name,
          email: email,
          password: pass,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ ${state.message}")),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          } else if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final loading = state is SignupLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // الخلفية الزرقاء
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(130),
                      ),
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

                // الدائرة الذهبية
                Positioned(
                  top: -60,
                  right: -60,
                  child: CircleAvatar(
                    backgroundColor: kAccentColor,
                    radius: 80,
                  ),
                ),

                // المحتوى
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 300,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildTextField(Icons.person, "User Name",
                          controller: nameController),
                      SizedBox(height: 20),
                      _buildTextField(Icons.email, "Email",
                          controller: emailController),
                      SizedBox(height: 20),
                      _buildTextField(Icons.lock, "Password",
                          controller: passwordController, isPassword: true),
                      SizedBox(height: 20),
                      _buildTextField(Icons.lock, "Confirm Password",
                          controller: confirmController, isPassword: true),
                      SizedBox(height: 30),

                      _buildButton(
                        context,
                        loading ? "Signing Up..." : "Sign Up",
                        enabled: !loading,
                        onPressed: () => _onSignupPressed(context),
                      ),

                      SizedBox(height: 20),
                      _buildBottomText(
                        context,
                        "You already have an account? ",
                        "Login",
                        LoginScreen(),
                      ),
                    ],
                  ),
                ),

                // زر الرجوع
                Positioned(
                  top: 50,
                  left: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: kPrimaryColor),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kAccentColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text,
      {required bool enabled, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: kAccentColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildBottomText(
      BuildContext context, String text, String action, Widget screen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          },
          child: Text(
            action,
            style: TextStyle(
              color: kAccentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
