import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial(0));

  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    emit(HomeTabChanged(index));
  }

  Future<void> loadDashboard() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(HomeLoaded({
      'updatedFlights': [
        {
          'route': 'Cairo → Dubai',
          'status': 'Delayed',
          'time': 'Departure 10:30 AM · Gate A12',
          'airline': 'Egypt Air',
          'flight_no': 'MS804',
        },
        {
          'route': 'Cairo → Paris',
          'status': 'Gate changed',
          'time': 'Departure 01:15 PM · Gate B5',
          'airline': 'Air France',
          'flight_no': 'AF123',
        },
      ],
      'highlightedServices': [
        {
          'title': 'VIP Experience',
          'description':
              'Access exclusive lounges, fast track and premium services before your flight.',
        },
        {
          'title': 'Accessibility & Assistance',
          'description':
              'Request wheelchairs, escort services and tailored support at any time.',
        },
      ],
      'trackedFlight': {
        'flight_no': 'MS915',
        'route': 'Cairo → London',
        'status': 'Boarding in 20 minutes',
      },
    }));
  }
}
