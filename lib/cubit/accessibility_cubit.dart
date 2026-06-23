// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../data/repositories/services_repository.dart';
// import 'accessibility_state.dart';

// class AccessibilityCubit extends Cubit<AccessibilityState> {
//   final ServicesRepository _repository;

//   AccessibilityCubit(this._repository) : super(AccessibilityInitial());

//   Future<void> loadAccessibilityServices() async {
//     emit(AccessibilityLoading());
//     try {
//       final Response response = await _repository.getServices(
//         queryParams: {"category": "Accessibility"},
//       );
//       final List<dynamic> data = response.data["data"] ?? response.data;
//       emit(AccessibilityLoaded(data));
//     } catch (e) {
//       emit(AccessibilityError(e.toString()));
//     }
//   }
// }