import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/features/on_boarding/data/models/onboarding_page_data.dart';
import 'package:gate_buddy/features/on_boarding/logic/cubit/onboarding_cubit.dart';
import 'package:gate_buddy/features/on_boarding/ui/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/images/on_boarding_1.png',
      titleKey: 'onboarding.page1_title',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/on_boarding_2.png',
      titleKey: 'onboarding.page2_title',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/on_boarding_3.png',
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
      _navigateToWelcome();
      return;
    }
    cubit.nextPage();
    _animateTo(state.currentPage + 1);
  }

  void _onBack(OnboardingCubit cubit, OnboardingState state) {
    cubit.previousPage();
    _animateTo(state.currentPage - 1);
  }

  void _navigateToWelcome() {
    context.pushReplacementNamed(Routes.welcome);
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
                  onSkip: _navigateToWelcome,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
