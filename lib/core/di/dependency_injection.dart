import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/dio_consumer.dart';
import 'package:gate_buddy/data/repositories/dashboard_repository.dart';
import 'package:gate_buddy/features/auth/data/remote/auth_remote_ds.dart';
import 'package:gate_buddy/features/auth/data/repo/auth_repo_impl.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/explore_places/data/remote/explore_places_remote_ds.dart';
import 'package:gate_buddy/features/explore_places/data/repo/explore_places_repo_impl.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/indoor_map/data/remote/indoor_map_remote_ds.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo_impl.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/dio_factory.dart';
import '../config/app_config.dart';
import '../networking/network_info.dart';
import '../service/secure_storage.dart';
import '../utils/app_constants.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencies() async {
  // External
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  final storage = FlutterSecureStorage();

  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage(storage));

  // Core Network
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Dio
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(
      baseUrl: AppConfig.baseUrl,
      getToken: () async {
        return await getIt<SecureStorage>().read(key: AppConstants.userDataKey);
      },
      enableLogging: AppConfig.enableLogging,
    ),
  );

  // --- Repositories ---
  getIt.registerLazySingleton(
    () => DashboardRepository(api: getIt<ApiConsumer>()),
  );

  // --- Api ---
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));

  // Auth
  getIt.registerLazySingleton(() => AuthRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton(
    () => AuthRepoImpl(remote: getIt<AuthRemoteDs>()),
  );
  getIt.registerLazySingleton(() => AuthCubit(repo: getIt<AuthRepoImpl>()));

  // Indoor Map
  getIt.registerLazySingleton<IndoorMapRemoteDs>(
    () => IndoorMapRemoteDs(api: getIt()),
  );
  getIt.registerLazySingleton<IndoorMapRepo>(
    () => IndoorMapRepoImpl(remoteDs: getIt()),
  );
  getIt.registerLazySingleton<IndoorMapCubit>(
    () => IndoorMapCubit(indoorMapRepo: getIt()),
  );

  // Explore Places
  getIt.registerLazySingleton(
    () => ExplorePlacesRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => ExplorePlacesRepoImpl(remoteDs: getIt<ExplorePlacesRemoteDs>()),
  );
  getIt.registerLazySingleton(
    () => ExploreCubit(repo: getIt<ExplorePlacesRepoImpl>()),
  );
}
