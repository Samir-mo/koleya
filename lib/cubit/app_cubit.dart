import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/service_model.dart';
import '../data/repositories/airport_repository.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  final AirportRepository _repo = AirportRepository();

  /// تحميل قائمة الخدمات من الـ API
  Future<void> loadServices() async {
    emit(AppLoading());
    try {
      // 📌 TODO: هنا هتحط استدعاء الـ API الحقيقي لما يكون جاهز لاحقًا
      //
      // مثال:
      // final services = await _repo.getServices();
      // emit(AppLoaded(services));

      // 👇 بيانات تجريبية مؤقتة
      await Future.delayed(const Duration(seconds: 2));

      final demoServices = <ServiceModel>[
        ServiceModel(
          id: 1,
          name: "Flight Assistance",
          description: "Help with boarding process",
        ),
        ServiceModel(
          id: 2,
          name: "VIP Lounge",
          description: "Relax in our premium lounges",
        ),
        ServiceModel(
          id: 3,
          name: "Baggage Support",
          description: "Quick luggage handling service",
        ),
      ];

      emit(AppLoaded(demoServices));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }
}