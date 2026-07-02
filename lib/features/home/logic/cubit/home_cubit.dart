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
      final flightId = data.userTrack?.flight.id;
      if (flightId != null && flightId.isNotEmpty) loadFlightUpdates(flightId);
    } on AppException catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.message));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }

  /// Loads live field-change updates for the tracked flight [flightId] —
  /// supplemental to the dashboard, so it's tracked via its own status/error
  /// and never overwrites `status`.
  Future<void> loadFlightUpdates(String flightId) async {
    emit(
      state.copyWith(
        flightUpdatesStatus: HomeStatus.loading,
        clearFlightUpdatesError: true,
      ),
    );
    try {
      final updates = await repo.getFlightUpdates(flightId);
      emit(
        state.copyWith(
          flightUpdatesStatus: HomeStatus.success,
          flightUpdates: updates,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          flightUpdatesStatus: HomeStatus.failure,
          flightUpdatesError: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          flightUpdatesStatus: HomeStatus.failure,
          flightUpdatesError: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() => loadDashboard();
}
