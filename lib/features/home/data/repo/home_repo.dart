import '../models/home_model.dart';
import '../../../flights/data/models/flight_model.dart';

abstract class HomeRepo {
  Future<HomeModel> getHomeData();
  Future<List<FlightModel>> getFlightUpdates();
}
