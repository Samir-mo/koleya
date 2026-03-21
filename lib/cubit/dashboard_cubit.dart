import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/models/dashboard_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repo = DashboardRepository();

  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final response = await _repo.getDashboardData();
      final data = response.data;

      final dashboard = DashboardModel.fromJson(
          data is Map ? data["data"] ?? data : {});

      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}