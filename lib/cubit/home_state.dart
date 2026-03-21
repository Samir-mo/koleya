import 'package:equatable/equatable.dart';

/// الحالات الخاصة بالـ Home Screen
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  final int index;
  const HomeInitial(this.index);

  @override
  List<Object?> get props => [index];
}

/// لتغيير التبويب (Tab)
class HomeTabChanged extends HomeState {
  final int index;
  const HomeTabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

/// أثناء تحميل بيانات الـ Dashboard
class HomeLoading extends HomeState {}

/// عند اكتمال تحميل البيانات بنجاح
class HomeLoaded extends HomeState {
  final Map<String, dynamic> data;
  const HomeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// في حالة حدوث خطأ
class HomeError extends HomeState {
  final String error;
  const HomeError(this.error);

  @override
  List<Object?> get props => [error];
}
