import '../models/home_model.dart';

abstract class HomeRepo {
  Future<HomeModel> getHomeData();
}
