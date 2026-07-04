import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../data/repo/flight_updates_repo.dart';
import 'flight_updates_list_state.dart';

class FlightUpdatesListCubit extends Cubit<FlightUpdatesListState> {
  final FlightUpdatesRepo repo;
  static const int _pageSize = 30;

  FlightUpdatesListCubit({required this.repo})
      : super(const FlightUpdatesListState());

  Future<void> loadFlights() async {
    emit(state.copyWith(status: FlightUpdatesStatus.loading, clearError: true));
    try {
      final flights = await repo.getUpdatedFlights(
        limit: _pageSize,
        page: 0,
      );
      emit(
        state.copyWith(
          status: FlightUpdatesStatus.success,
          flights: flights,
          currentPage: 0,
          hasMore: flights.length >= _pageSize,
        ),
      );
    } catch (e) {
      final error = e is Failure ? e.message : e.toString();
      emit(state.copyWith(
        status: FlightUpdatesStatus.failure,
        error: error,
      ));
    }
  }

  Future<void> loadMoreFlights() async {
    if (!state.hasMore || state.isLoading) return;

    try {
      final nextPage = state.currentPage + 1;
      final newFlights = await repo.getUpdatedFlights(
        limit: _pageSize,
        page: nextPage,
      );

      if (newFlights.isEmpty) {
        emit(state.copyWith(hasMore: false));
        return;
      }

      final allFlights = [...state.flights, ...newFlights];
      emit(
        state.copyWith(
          flights: allFlights,
          currentPage: nextPage,
          hasMore: newFlights.length >= _pageSize,
        ),
      );
    } catch (e) {
      final error = e is Failure ? e.message : e.toString();
      emit(state.copyWith(
        status: FlightUpdatesStatus.failure,
        error: error,
      ));
    }
  }

  Future<void> refresh() => loadFlights();
}
