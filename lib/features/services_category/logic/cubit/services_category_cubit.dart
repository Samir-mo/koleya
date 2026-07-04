import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/services_category_repo.dart';
import 'services_category_state.dart';

class ServicesCategoryCubit extends Cubit<ServicesCategoryState> {
  final ServicesCategoryRepo repo;

  ServicesCategoryCubit({required this.repo})
    : super(const ServicesCategoryState());

  Future<void> load(String category) async {
    emit(
      state.copyWith(
        status: ServicesCategoryStatus.loading,
        category: category,
      ),
    );

    final result = await repo.getByCategory(category);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ServicesCategoryStatus.failure,
          error: failure.message,
        ),
      ),
      (services) => emit(
        state.copyWith(
          status: ServicesCategoryStatus.success,
          services: services,
        ),
      ),
    );
  }

  Future<void> refresh() => load(state.category);
}
