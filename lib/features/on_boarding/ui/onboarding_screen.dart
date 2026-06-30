import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../data/models/onboarding_page_data.dart';
import '../logic/cubit/onboarding_cubit.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: AppAssets.onboardingPage1,
      titleKey: 'onboarding.page1_title',
    ),
    OnboardingPageData(
      imagePath: AppAssets.onboardingPage2,
      titleKey: 'onboarding.page2_title',
    ),
    OnboardingPageData(
      imagePath: AppAssets.onboardingPage3,
      titleKey: 'onboarding.page3_title',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onNext(OnboardingCubit cubit, OnboardingState state) {
    if (state.isLastPage) {
      _navigateToLogin();
      return;
    }
    cubit.nextPage();
    _animateTo(state.currentPage + 1);
  }

  void _onBack(OnboardingCubit cubit, OnboardingState state) {
    cubit.previousPage();
    _animateTo(state.currentPage - 1);
  }

  void _navigateToLogin() {
    context.pushReplacementNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();
              return PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (_, index) => OnboardingPage(
                  data: _pages[index],
                  currentIndex: state.currentPage,
                  totalPages: OnboardingCubit.totalPages,
                  onNext: () => _onNext(cubit, state),
                  onBack: () => _onBack(cubit, state),
                  onSkip: _navigateToLogin,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
