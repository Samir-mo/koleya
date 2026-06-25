import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/dio_consumer.dart';
import 'package:gate_buddy/features/auth/data/remote/auth_remote_ds.dart';
import 'package:gate_buddy/features/auth/data/repo/auth_repo.dart';
import 'package:gate_buddy/features/auth/data/repo/auth_repo_impl.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/forget_password_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/verify_code_cubit.dart';
import 'package:gate_buddy/features/ai_chat/data/remote/ai_chat_remote_ds.dart';
import 'package:gate_buddy/features/ai_chat/data/repo/ai_chat_repo.dart';
import 'package:gate_buddy/features/ai_chat/data/repo/ai_chat_repo_impl.dart';
import 'package:gate_buddy/features/ai_chat/logic/cubit/ai_chat_cubit.dart';
import 'package:gate_buddy/features/explore_places/data/remote/explore_places_remote_ds.dart';
import 'package:gate_buddy/features/explore_places/data/repo/explore_places_repo_impl.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/flights/data/remote/flights_remote_ds.dart';
import 'package:gate_buddy/features/flights/data/repo/flights_repo.dart';
import 'package:gate_buddy/features/flights/data/repo/flights_repo_impl.dart';
import 'package:gate_buddy/features/flights/logic/cubit/flights_cubit.dart';
import 'package:gate_buddy/features/indoor_map/data/remote/indoor_map_remote_ds.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo_impl.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/notifications/logic/cubit/notifications_cubit.dart';
import 'package:gate_buddy/features/profile/logic/cubit/profile_cubit.dart';
import 'package:gate_buddy/features/search/logic/cubit/search_cubit.dart';
import 'package:gate_buddy/features/services/logic/cubit/services_cubit.dart';
import 'package:gate_buddy/features/tracked_flight/logic/cubit/tracked_flight_cubit.dart';
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
  getIt.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(),
  );

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
  getIt.registerLazySingleton(
    () => AuthRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      remoteDs: getIt<AuthRemoteDs>(),
      storage: getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton(
    () => AuthCubit(repo: getIt<AuthRepo>()),
  );
  getIt.registerFactory(
    () => ForgetPasswordCubit(repo: getIt<AuthRepo>()),
  );
  getIt.registerFactory(
    () => VerifyCodeCubit(repo: getIt<AuthRepo>()),
  );

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
  getIt.registerLazySingleton<IndoorMapRemoteDs>(
    () => IndoorMapRemoteDs(api: getIt()),
  );
  getIt.registerLazySingleton<IndoorMapRepo>(
    () => IndoorMapRepoImpl(remoteDs: getIt()),
  );
  getIt.registerLazySingleton<IndoorMapCubit>(
    () => IndoorMapCubit(indoorMapRepo: getIt()),
  );

  // ── Explore Places ────────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => ExplorePlacesRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => ExplorePlacesRepoImpl(remoteDs: getIt<ExplorePlacesRemoteDs>()),
  );
  getIt.registerLazySingleton(
    () => ExploreCubit(repo: getIt<ExplorePlacesRepoImpl>()),
  );

  // ── Flights ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => FlightsRemoteDs(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<FlightsRepo>(
    () => FlightsRepoImpl(remoteDs: getIt<FlightsRemoteDs>()),
  );
  getIt.registerFactory(() => FlightsCubit(repo: getIt<FlightsRepo>()));

  // ── Notifications ─────────────────────────────────────────────────────────
  getIt.registerFactory(() => NotificationsCubit());

  // ── Services ──────────────────────────────────────────────────────────────
  getIt.registerFactory(() => ServicesCubit());

  // ── Profile ───────────────────────────────────────────────────────────────
  getIt.registerFactory(() => ProfileCubit());

  // ── Search ────────────────────────────────────────────────────────────────
  getIt.registerFactory(() => SearchCubit());

  // ── Tracked Flight ────────────────────────────────────────────────────────
  getIt.registerFactory(() => TrackedFlightCubit());
}
