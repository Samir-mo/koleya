import '../models/home_model.dart';
import '../remote/home_remote_ds.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDs remoteDs;
  const HomeRepoImpl({required this.remoteDs});

  @override
  Future<HomeModel> getHomeData() => remoteDs.getHomeData();
}
