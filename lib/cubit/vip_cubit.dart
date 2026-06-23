// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../data/repositories/services_repository.dart';
// import 'vip_state.dart';

// class VipCubit extends Cubit<VipState> {
//   final ServicesRepository _repository;

//   VipCubit(this._repository) : super(VipInitial());

//   Future<void> loadVipServices() async {
//     emit(VipLoading());
//     try {
//       final Response response =
//           await _repository.getServices(queryParams: {"category": "VIP"});
//       final List<dynamic> data = response.data["data"] ?? response.data;
//       emit(VipLoaded(data));
//     } catch (e) {
//       emit(VipError(e.toString()));
//     }
//   }
// }