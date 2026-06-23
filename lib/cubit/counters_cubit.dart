// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gate_buddy/data/repositories/services_repository.dart';

// import 'counters_state.dart';

// class CountersCubit extends Cubit<CountersState> {
//   CountersCubit(ServicesRepository servicesRepository)
//     : super(CountersInitial());

//   // ==== Mock Data بدل الـ API مؤقتاً ====
//   static const List<Map<String, String>> _domesticMock = [
//     {
//       "title": "Counter D01",
//       "airline": "EgyptAir",
//       "location": "Terminal 2 - Zone B",
//       "status": "Open",
//     },
//     {
//       "title": "Counter I02",
//       "airline": "Qatar Airways",
//       "location": "Terminal 3 - Zone G",
//       "status": "Closed",
//     },
//   ];

//   static const List<Map<String, String>> _internationalMock = [
//     {
//       "title": "Counter I11",
//       "airline": "Emirates",
//       "location": "Terminal 3 - Zone A",
//       "status": "Open",
//     },
//     {
//       "title": "Counter I21",
//       "airline": "Lufthansa",
//       "location": "Terminal 3 - Zone C",
//       "status": "Closed",
//     },
//   ];

//   Future<void> loadCounters({String subCategory = "Domestic"}) async {
//     emit(CountersLoading());

//     // شوية Delay بسيط عشان يبين الـ Loader (اختياري)
//     await Future.delayed(const Duration(milliseconds: 300));

//     // استخدام Mock Data بدل API
//     if (subCategory == "Domestic") {
//       emit(CountersLoaded(List<dynamic>.from(_domesticMock)));
//     } else {
//       emit(CountersLoaded(List<dynamic>.from(_internationalMock)));
//     }

//     // ==== لما الـ API يشتغل فعلياً رجّع الكود ده وامسح اللي فوق ====
//     /*
//     try {
//       final Response response = await _repository.getServices(
//         queryParams: {"category": "Counters", "subcategory": subCategory},
//       );

//       final dynamic raw = response.data["data"] ?? response.data;

//       // تأكيد إنه List علشان مايحصلش مشاكل على الويب
//       final List<dynamic> data =
//           raw is List ? raw : <dynamic>[];

//       emit(CountersLoaded(data));
//     } catch (e) {
//       emit(CountersError(e.toString()));
//     }
//     */
//   }
// }
