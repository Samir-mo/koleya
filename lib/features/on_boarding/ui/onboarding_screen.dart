import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/data/storage/storage_helper.dart';
import 'package:gate_buddy/features/on_boarding/logic/cubit/onboarding_cubit.dart';
import 'package:gate_buddy/features/on_boarding/logic/cubit/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatefulWidget {
  const _OnboardingBody();

  @override
  State<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<_OnboardingBody> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/1.png",
      "text": "Easy to locate locations via map",
    },
    {
      "image": "assets/images/2.png",
      "text": "Get real-time flight information and updates",
    },
    {
      "image": "assets/images/3.png",
      "text": "Request assistance easily for passengers and chatbot support",
    },
  ];

  void _next(BuildContext context, int currentIndex) async {
    if (currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // 🧩 نحفظ إن المستخدم شاف شاشة Onboarding
      await StorageHelper.save("onboarding_seen", true);
      context.read<OnboardingCubit>().finishOnboarding();
      if (!mounted) return;

      // ننتقل مباشرة إلى شاشة تسجيل الدخول
      Navigator.pushNamed(context, Routes.login);
    }
  }

  Future<void> _skip(BuildContext context) async {
    // تنفيذ نفس وظيفة الـ next في آخر صفحة
    await StorageHelper.save("onboarding_seen", true);
    if (!mounted) return;
    Navigator.pushNamed(context, Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is OnboardingPageChanged) {
          currentIndex = state.currentPage;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) =>
                        context.read<OnboardingCubit>().changePage(index),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(_pages[index]['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: TextButton(
                                  onPressed: () => _skip(context),
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _pages[index]['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF002F6C),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: currentIndex == dotIndex ? 12.0 : 8.0,
                                height: currentIndex == dotIndex ? 12.0 : 8.0,
                                decoration: BoxDecoration(
                                  color: currentIndex == dotIndex
                                      ? const Color(0xFFD39A28)
                                      : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: ElevatedButton(
                              onPressed: () => _next(context, currentIndex),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF002F6C),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                currentIndex == _pages.length - 1
                                    ? "Get Started"
                                    : "Next",
                                style: const TextStyle(
                                  color: Color(0xFFFEBB49),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
