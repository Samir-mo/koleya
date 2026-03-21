import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/services_repository.dart';
import '../../data/models/service_model.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _repo = ServicesRepository();

  ServicesCubit() : super(ServicesInitial());

  Future<void> loadServices() async {
    emit(ServicesLoading());
    try {
      final response = await _repo.getServices();

      final data = response.data;
      List<ServiceModel> services = [];

      if (data is List) {
        services = data.map((e) => ServiceModel.fromJson(e)).toList();
      } else if (data is Map && data["data"] is List) {
        services =
            (data["data"] as List).map((e) => ServiceModel.fromJson(e)).toList();
      }

      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}