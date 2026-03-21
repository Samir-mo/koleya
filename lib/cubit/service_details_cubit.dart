import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/services_repository.dart';
import 'service_details_state.dart';

/// مسئول عن جلب خدمات فئة معينة من السيرفر
class ServiceDetailsCubit extends Cubit<ServiceDetailsState> {
  final ServicesRepository _repository;

  ServiceDetailsCubit(this._repository) : super(ServiceDetailsInitial());

  /// جلب الخدمات حسب الفئة
  Future<void> loadCategoryServices(String category) async {
    emit(ServiceDetailsLoading());
    try {
      final Response response =
          await _repository.getServices(queryParams: {"category": category});
      final List<dynamic> data = response.data["data"] ?? response.data;
      emit(ServiceDetailsLoaded(data));
    } catch (e) {
      emit(ServiceDetailsError(e.toString()));
    }
  }
}