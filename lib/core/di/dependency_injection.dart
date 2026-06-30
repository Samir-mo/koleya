import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_consumer.dart';
import '../api/dio_consumer.dart';
import '../../features/auth/data/remote/auth_remote_ds.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';
import '../../features/auth/logic/cubit/forget_password_cubit.dart';
import '../../features/auth/logic/cubit/verify_code_cubit.dart';
import '../../features/ai_chat/data/remote/ai_chat_remote_ds.dart';
import '../../features/ai_chat/data/repo/ai_chat_repo.dart';
import '../../features/ai_chat/data/repo/ai_chat_repo_impl.dart';
import '../../features/ai_chat/logic/cubit/ai_chat_cubit.dart';
import '../shared/data/services_data_source.dart';
import '../../features/profile/data/remote/profile_remote_ds.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/profile/data/repo/profile_repo_impl.dart';
import '../../features/explore_places/data/repo/explore_places_repo.dart';
import '../../features/explore_places/data/repo/explore_places_repo_impl.dart';
import '../../features/explore_places/logic/explore_cubit.dart';
import '../../features/flights/data/remote/flights_remote_ds.dart';
import '../../features/flights/data/repo/flights_repo.dart';
import '../../features/flights/data/repo/flights_repo_impl.dart';
import '../../features/flights/logic/cubit/flights_cubit.dart';
import '../../features/indoor_map/data/repo/indoor_map_repo.dart';
import '../../features/indoor_map/data/repo/indoor_map_repo_impl.dart';
import '../../features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import '../../features/notifications/logic/cubit/notifications_cubit.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/search/data/remote/search_remote_ds.dart';
import '../../features/search/data/repo/search_repo.dart';
import '../../features/search/data/repo/search_repo_impl.dart';
import '../../features/search/logic/cubit/search_cubit.dart';
import '../../features/boarding_pass_scan/logic/cubit/boarding_pass_scan_cubit.dart';
import '../../features/services_category/data/repo/services_category_repo.dart';
import '../../features/services_category/data/repo/services_category_repo_impl.dart';
import '../../features/services_category/logic/cubit/services_category_cubit.dart';
import '../../features/home/data/remote/home_remote_ds.dart';
import '../../features/home/data/repo/home_repo.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import '../../features/home/logic/cubit/home_cubit.dart';
import '../../features/tracked_flight/data/remote/tracked_flight_remote_ds.dart';
import '../../features/tracked_flight/data/repo/tracked_flight_repo.dart';
import '../../features/tracked_flight/data/repo/tracked_flight_repo_impl.dart';
import '../../features/tracked_flight/logic/cubit/tracked_flight_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/dio_factory.dart';
import '../config/app_config.dart';
import '../networking/network_info.dart';
import '../service/secure_storage.dart';
import '../utils/app_constants.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // ── External ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  const storage = FlutterSecureStorage();
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage(storage));

  // ── Core Network ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // ── Dio ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(
      baseUrl: AppConfig.baseUrl,
      getToken: () async =>
          await getIt<SecureStorage>().read(key: AppConstants.accessTokenKey),
      enableLogging: AppConfig.enableLogging,
    ),
  );

  // ── ApiConsumer — MUST be registered before any repository ───────────────
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));

  // ── Auth ─────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => AuthRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      remoteDs: getIt<AuthRemoteDs>(),
      storage: getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton(() => AuthCubit(repo: getIt<AuthRepo>()));
  getIt.registerFactory(() => ForgetPasswordCubit(repo: getIt<AuthRepo>()));
  getIt.registerFactory(() => VerifyCodeCubit(repo: getIt<AuthRepo>()));

  // ── Chat Bot / Assistant ──────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => AssistantRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AssistantRepo>(
    () => AssistantRepoImpl(remoteDs: getIt<AssistantRemoteDs>()),
  );
  getIt.registerLazySingleton(
    () => AssistantCubit(repo: getIt<AssistantRepo>()),
  );

  // ── Indoor Map ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<IndoorMapRepo>(
    () => IndoorMapRepoImpl(dataSource: getIt<ServicesDataSource>()),
  );
  getIt.registerLazySingleton<IndoorMapCubit>(
    () => IndoorMapCubit(indoorMapRepo: getIt()),
  );

  // ── Shared Services Data Source (used by Explore + Indoor Map) ──────────
  getIt.registerLazySingleton(
    () => ServicesDataSource(api: getIt<ApiConsumer>()),
  );

  // ── Explore Places ────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ExplorePlacesRepo>(
    () => ExplorePlacesRepoImpl(dataSource: getIt<ServicesDataSource>()),
  );
  getIt.registerFactory(() => ExploreCubit(repo: getIt<ExplorePlacesRepo>()));

  // ── Flights ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => FlightsRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton<FlightsRepo>(
    () => FlightsRepoImpl(remoteDs: getIt<FlightsRemoteDs>()),
  );
  getIt.registerFactory(() => FlightsCubit(repo: getIt<FlightsRepo>()));

  // ── Notifications ─────────────────────────────────────────────────────────
  getIt.registerFactory(() => NotificationsCubit());

  // ── Boarding Pass Scanner ─────────────────────────────────────────────────
  getIt.registerFactory(
    () => BoardingPassScanCubit(flightsRepo: getIt<FlightsRepo>()),
  );

  // ── Services Category ─────────────────────────────────────────────────────
  getIt.registerLazySingleton<ServicesCategoryRepo>(
    () => ServicesCategoryRepoImpl(dataSource: getIt<ServicesDataSource>()),
  );
  getIt.registerFactory(
    () => ServicesCategoryCubit(repo: getIt<ServicesCategoryRepo>()),
  );

  // ── Profile ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => ProfileRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteDs: getIt<ProfileRemoteDs>()),
  );
  getIt.registerFactory(() => ProfileCubit());

  // ── Search ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => SearchRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton<SearchRepo>(
    () => SearchRepoImpl(remoteDs: getIt<SearchRemoteDs>()),
  );
  getIt.registerFactory(() => SearchCubit(repo: getIt<SearchRepo>()));

  // ── Home ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => HomeRemoteDs(api: getIt<ApiConsumer>()));
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(remoteDs: getIt<HomeRemoteDs>()),
  );
  getIt.registerFactory(() => HomeCubit(repo: getIt<HomeRepo>()));

  // ── Tracked Flight ────────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => TrackedFlightRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<TrackedFlightRepo>(
    () => TrackedFlightRepoImpl(remoteDs: getIt<TrackedFlightRemoteDs>()),
  );
  getIt.registerFactory(
    () => TrackedFlightCubit(repo: getIt<TrackedFlightRepo>()),
  );
}
