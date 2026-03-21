import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/dashboard_repository.dart';
import 'home_state.dart';

/// HomeCubit — مسئول عن إدارة التبويبات و تحميل بيانات الصفحة الرئيسية
class HomeCubit extends Cubit<HomeState> {
  final DashboardRepository _dashboardRepository;

  // 👈 فلاغ: true يعني شغال Mock، false يعني يرجع يستخدم الـ API الحقيقي
  static const bool useMockDashboard = true;

  HomeCubit(this._dashboardRepository) : super(const HomeInitial(0));

  int currentIndex = 0;

  /// 🔹 تغيير التبويب (Tab)
  void changeTab(int index) {
    currentIndex = index;
    emit(HomeTabChanged(index));
  }

  /// 📊 تحميل بيانات الـ Dashboard / Home
  Future<void> loadDashboard() async {
    emit(HomeLoading());

    // ✅ مود الـ Mock: من غير API نهائيًا
    if (useMockDashboard) {
      await Future.delayed(const Duration(milliseconds: 800));

      final Map<String, dynamic> mockData = <String, dynamic>{
        "updatedFlights": [
          {
            "route": "Cairo → Dubai",
            "status": "Delayed",
            "time": "Departure 10:30 AM · Gate A12",
            "airline": "Egypt Air",
            "flight_no": "MS804",
          },
          {
            "route": "Cairo → Paris",
            "status": "Gate changed",
            "time": "Departure 01:15 PM · Gate B5",
            "airline": "Air France",
            "flight_no": "AF123",
          },
        ],
        "highlightedServices": [
          {
            "title": "VIP Experience",
            "description":
                "Access exclusive lounges, fast track and premium services before your flight.",
          },
          {
            "title": "Accessibility & Assistance",
            "description":
                "Request wheelchairs, escort services and tailored support at any time.",
          },
        ],
        "trackedFlight": {
          "flight_no": "MS915",
          "route": "Cairo → London",
          "status": "Boarding in 20 minutes",
        },
      };

      emit(HomeLoaded(mockData));
      return;
    }

    // ✅ مود الـ API الحقيقي (هيرجع تفعّله بعدين)
    try {
      final Response response = await _dashboardRepository.getHomeData();
      final Map<String, dynamic> homeData = response.data;

      emit(HomeLoaded(homeData));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
