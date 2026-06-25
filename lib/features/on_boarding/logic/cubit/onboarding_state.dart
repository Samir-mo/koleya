part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({this.currentPage = 0});

  final int currentPage;

  bool get isLastPage => currentPage == OnboardingCubit.totalPages - 1;
  bool get isFirstPage => currentPage == 0;

  OnboardingState copyWith({int? currentPage}) =>
      OnboardingState(currentPage: currentPage ?? this.currentPage);

  @override
  List<Object> get props => [currentPage];
}
