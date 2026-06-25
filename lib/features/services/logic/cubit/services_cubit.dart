import 'package:flutter_bloc/flutter_bloc.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(const ServicesInitial());

  Future<void> loadServices() async {}
  Future<void> loadServiceById(String id) async {}
  Future<void> loadVipLounges() async {}
}
