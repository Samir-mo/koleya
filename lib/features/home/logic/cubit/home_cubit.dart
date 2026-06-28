import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/errors/exceptions.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit({required this.repo}) : super(const HomeState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    try {
      final data = await repo.getHomeData();
      emit(state.copyWith(status: HomeStatus.success, data: data));
    } on AppException catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.message));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }

  Future<void> refresh() => loadDashboard();
}
