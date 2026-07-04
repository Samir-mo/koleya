import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
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
      // Load recently updated flights in parallel
      loadUpdatedFlights();
    } on AppException catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.message));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }

  /// Loads recently updated flights from `/flights/updated` endpoint.
  /// Non-fatal if it fails since it's supplemental to the dashboard.
  Future<void> loadUpdatedFlights() async {
    try {
      final flights = await repo.getFlightUpdates();
      if (!isClosed) emit(state.copyWith(updatedFlights: flights));
    } catch (_) {
      // Non-fatal — updated flights are supplemental
    }
  }

  Future<void> refresh() => loadDashboard();
}
