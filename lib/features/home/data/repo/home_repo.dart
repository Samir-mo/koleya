import '../models/home_model.dart';
import '../../../flights/data/models/flight_model.dart';
import '../../../tracked_flight/data/models/my_flight_response_model.dart';

abstract class HomeRepo {
  Future<HomeModel> getHomeData();
  Future<List<FlightModel>> getFlightUpdates();
  Future<MyFlightResponseModel> getMyFlight();
}
