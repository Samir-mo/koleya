// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../data/repositories/services_repository.dart';
// import 'financial_state.dart';

// class FinancialCubit extends Cubit<FinancialState> {
//   final ServicesRepository _repository;

//   FinancialCubit(this._repository) : super(FinancialInitial());

//   Future<void> loadFinancialServices(String subcategory) async {
//     emit(FinancialLoading());
//     try {
//       final Response response = await _repository.getServices(
//         queryParams: {"category": "Financial", "subcategory": subcategory},
//       );
//       final List<dynamic> data = response.data["data"] ?? response.data;
//       emit(FinancialLoaded(data));
//     } catch (e) {
//       emit(FinancialError(e.toString()));
//     }
//   }
// }