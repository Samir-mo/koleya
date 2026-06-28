# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gate Buddy is a Flutter airport companion app that helps travelers navigate airports, track flights, explore terminal services, and get AI-powered assistance. It targets Android and iOS and supports both English and Arabic.

## Architecture

Feature-first layered architecture. Each feature under `lib/features/<feature>/` has three layers:

```Shell
data/
  models/       # JSON-serializable data models
  remote/       # *RemoteDs — raw API calls via ApiConsumer
  repo/         # Abstract repo interface + *RepoImpl
logic/
  cubit/        # Cubit + State (flutter_bloc)
ui/
  <feature>_screen.dart
  widgets/
```

**Core layer** (`lib/core/`):

| Path                                  | Responsibility                                                                                        |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `api/`                              | `ApiConsumer` interface; `DioConsumer` implementation; `DioFactory` (auth interceptor, logging) |
| `config/app_config.dart`            | `ENV` dart-define, base URL, feature flags                                                          |
| `di/dependency_injection.dart`      | Single`GetIt` registry — the only place dependencies are registered                                |
| `router/app_router.dart`            | Named-route`generateRoute` with slide transitions; route names in `Routes` constants              |
| `themes/app_colors.dart`            | Static brand palette (`AppColors`)                                                                  |
| `themes/custom_colors.dart`         | Semantic theme tokens (`CustomColors`) — light/dark aware                                          |
| `utils/extensions/context_ext.dart` | `context.customColors`, `context.pushNamed(...)`, snackbar helpers                                |
| `service/secure_storage.dart`       | Token persistence via`FlutterSecureStorage`                                                         |
| `errors/`                           | `Failure`, `ServerException`, `DioHandler`, `ErrorHandler`                                    |

**Bootstrap flow:** `main_dev.dart` / `main_prod.dart` → `GateBuddyApp` → `_AppBootstrap` listens to `AuthCubit`. Authenticated → `MainScaffold`; unauthenticated/error → `OnboardingScreen`.

**Bottom navigation** (`MainScaffold`): 5 tabs via `persistent_bottom_nav_bar` — Indoor Map (0), Flights (1), Home (2, default), Explore Places (3), AI Assistant (4).

## Tech Stack

| Concern           | Package                           | Version          |
| ----------------- | --------------------------------- | ---------------- |
| Language          | Dart                              | ^3.8.1           |
| Framework         | Flutter                           | SDK              |
| State management  | flutter_bloc / hydrated_bloc      | ^9.1.1 / ^11.0.0 |
| DI                | get_it                            | ^7.7.0           |
| Networking        | dio                               | ^5.9.0           |
| Secure storage    | flutter_secure_storage            | ^9.2.2           |
| Preferences       | shared_preferences                | ^2.5.3           |
| Localization      | easy_localization                 | ^3.0.8           |
| Responsive sizing | flutter_screenutil                | ^5.9.3           |
| Maps              | google_maps_flutter + flutter_map | ^2.13.1 / ^8.3.0 |
| Navigation bar    | persistent_bottom_nav_bar         | ^6.2.1           |
| Fonts             | google_fonts                      | ^6.2.1           |
| Icons             | font_awesome_flutter              | ^10.9.1          |
| Animations        | flutter_animate                   | ^4.5.2           |

## Conventions

**File naming:** `snake_case` for all files and directories. Screens end in `_screen.dart`, cubits end in `_cubit.dart`, states in `_state.dart`, remote data sources in `_remote_ds.dart`, repos in `_repo.dart` / `_repo_impl.dart`.

**Colors:** Use `context.customColors.*` for semantic theme-aware colors. Use `AppColors.*` only for brand constants (e.g., splash screen, static decorations).

**Sizing:** Use ScreenUtil extensions (`.w`, `.h`, `.r`, `.sp`) — design base is 375×812.

**Localization:** Use `'key'.tr()` (easy_localization). Add keys to both `assets/lang/en.json` and `assets/lang/ar.json` together.

**Navigation:** Prefer `context.pushNamed(Routes.xxx, arguments: {...})` from `context_ext.dart`. Arguments are passed as `Map<String, dynamic>` and unpacked in `AppRouter.generateRoute`.

**DI:** Register everything in `lib/core/di/dependency_injection.dart`. Use `registerLazySingleton` for shared services/repos and `registerFactory` for cubits that must not share state across screens.

**Cubit provision:** Provide cubits at the screen level via `BlocProvider`. Root-level providers in `GateBuddyApp` are limited to `AppSettingsCubit` and `AuthCubit`.

**Constants:** Spacing, radius, icon sizes, storage keys, and regex patterns live in `lib/core/utils/app_constants.dart`.

## Do

- Access theme-aware colors through `context.customColors` — never hardcode hex values in widgets.
- Run `dart run build_runner build --delete-conflicting-outputs` after adding or changing mockito mocks.
- Use `flutter analyze` before committing to catch lint violations.
- Keep localization keys in sync across `en.json` and `ar.json`.
- Use `Routes.*` constants (not string literals) when navigating.
- Extend `ApiConsumer` for any new HTTP method needed.

## Don't

- Don't add new global `BlocProvider`s to `GateBuddyApp` — cubit scope should stay at the feature level.
- Don't call `getIt.registerX(...)` outside `dependency_injection.dart`.
- Don't use `MediaQuery.of(context).size` — use ScreenUtil extensions or `context.screenWidth` / `context.screenHeight`.
- Don't hardcode strings displayed to users — always use localization keys.
- Don't import feature A directly from feature B — communicate through shared models in `lib/core/shared/models/` or navigation arguments.

## Error Handling

All errors flow through a single pipeline: `DioException` → `AppException` → `Failure` → UI.

**Remote Data Source layer:**
```dart
try {
  final response = await api.get(...);
  return Model.fromJson(response);
} catch (e) {
  ErrorHandler.handle(e); // throws AppException; DioException → AppException
}
```

**Repository layer:**
```dart
@override
Future<Model> fetch() => remoteDs.fetch(); // propagate AppException to cubit
// OR convert to Failure if you need Either<Failure, T>:
// try {
//   return await remoteDs.fetch();
// } catch (e) {
//   return ErrorHandler.handleFailure(e); // AppException → Failure
// }
```

**Cubit layer:**
```dart
try {
  final result = await _repo.fetch();
  emit(state.copyWith(status: Status.success, data: result));
} on AppException catch (e) {
  emit(state.copyWith(status: Status.failure, error: e.message));
}
```

**Error classes:**
- `AppException` — base; thrown by RemoteDs. Has `message` (localization key) and `statusCode`.
  - Subclasses: `ServerException`, `NetworkException`, `UnauthorizedException`, `ForbiddenException`, `NotFoundException`, `TimeoutException`, `ValidationException`, `ParseException`, `ConflictException`, `TooManyRequestsException`.
- `Failure` — base; returned by repos. Has `message` (localization key) and `code`.
  - Subclasses: `ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `ForbiddenFailure`, `NotFoundFailure`, `ValidationFailure`, `TimeoutFailure`, `ConflictFailure`, `TooManyRequestsFailure`, `UnknownFailure`.
- `DioHandler` — maps `DioException` to `AppException`; extracts JSend `response.data['message']` if available.
- `ErrorHandler` — three entry points:
  - `ErrorHandler.handle(e)` → throws `AppException` (for RemoteDs)
  - `ErrorHandler.handleFailure(e)` → returns `Failure` (for repos)
  - `ErrorHandler.handleException(e)` → deprecated; use `handle()` instead (kept for backward compatibility)

All default error messages are localization keys under `errors.*` in both `en.json` and `ar.json`. Never hardcode error strings.
