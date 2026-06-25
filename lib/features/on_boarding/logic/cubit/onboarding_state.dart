import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageChanged extends OnboardingState {
  final int currentPage;
  OnboardingPageChanged(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}

class OnboardingFinished extends OnboardingState {}
