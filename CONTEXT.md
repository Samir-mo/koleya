# GateBuddy — Project Context for Claude

Paste this at the start of a new chat to continue with full context.

---

## Project Overview

**App:** GateBuddy — Flutter airport companion app (Android & iOS)  
**Branch:** `fix-api-integration`  
**Backend:** `https://gate-buddy-backend-production-f6df.up.railway.app/api/v1`  
**Architecture:** Feature-based clean architecture (data / logic / ui layers per feature)  
**State management:** `flutter_bloc` (Cubit pattern)  
**DI container:** `get_it` — `LazySingleton` for repos/data-sources/shared cubits, `Factory` for per-screen cubits  
**Navigation:** `persistent_bottom_nav_bar` (5 tabs) + named routes via `AppRouter`  
**Localization:** `easy_localization` — JSON files in `assets/lang/en.json` and `assets/lang/ar.json`  
**Theme persistence:** `HydratedBloc` via `AppSettingsCubit`  
**Responsive sizing:** `flutter_screenutil` — design base 375 × 812; use `.w .h .r .sp`

---

## Folder Structure (per feature)

```
lib/features/<feature>/
  data/
    models/           ← Dart models with fromJson/toJson
    remote/           ← <Feature>RemoteDs  (calls DioConsumer, never touches .data)
    repo/             ← <Feature>Repo (abstract) + <Feature>RepoImpl
  logic/
    cubit/            ← <Feature>Cubit + <Feature>State
  ui/
    <feature>_screen.dart
    widgets/          ← private widgets for this feature only
```

**Core layer:**
```
lib/core/
  api/
    api_consumer.dart       ← ApiConsumer interface (get/post/put/patch/delete)
    dio_consumer.dart       ← Implementation — returns response.data directly
    dio_factory.dart        ← Builds Dio with AuthInterceptor + LoggerInterceptor
    api_endpoints.dart      ← All endpoint strings (never inline them in data sources)
    api_interceptors.dart   ← AuthInterceptor reads token automatically
  config/app_config.dart    ← ENV dart-define, base URL, feature flags
  di/dependency_injection.dart  ← ONLY place getIt.registerX() is called
  router/
    app_router.dart         ← generateRoute, slide transition, unpacks Map args
    routes.dart             ← All route name constants (Routes.xxx)
  errors/
    exceptions.dart         ← AppException hierarchy (Server/Network/Auth/Validation…)
    failure.dart            ← Failure hierarchy mirrors exceptions
    error_handler.dart      ← handleException() for DS, handleFailure() for Repo
  service/secure_storage.dart   ← FlutterSecureStorage wrapper
  settings/cubit/
    app_settings_cubit.dart ← HydratedBloc — theme, locale, font
    app_settings_state.dart
  themes/
    app_colors.dart         ← Static brand palette (AppColors)
    custom_colors.dart      ← Semantic theme-aware tokens (CustomColors)
    theme_data/             ← getLightTheme() / getDarkTheme()
  utils/
    app_constants.dart      ← Storage keys, spacing, radius, validation lengths
    extensions/
      context_ext.dart      ← context.customColors, navigation helpers, snackbars
```

---

## Critical Rules — Never Break These

### 1. DioConsumer already unwraps `.data`

`api.get/post/patch/delete/put()` returns the **decoded body** directly (i.e., `response.data` from Dio).  
**Never call `.data` again** in a RemoteDs.

```dart
// ✅ correct
final json = await api.get('/endpoint') as Map<String, dynamic>;

// ❌ wrong — response is already the body, not a Response object
final response = await api.get('/endpoint');
final json = response.data;
```

**Exception:** When the backend wraps the payload in `{ "data": { ... } }`, unwrap that manually:
```dart
final response = await api.get(ApiEndpoints.getProfile);
final data = (response as Map<String, dynamic>)['data'];
final userMap = data is Map ? data['user'] ?? data : data;
```

### 2. Error handling — two distinct layers

| Layer | What to call | What it does |
|---|---|---|
| RemoteDs | `ErrorHandler.handleException(e)` | Re-throws or wraps in `AppException` |
| RepoImpl | `ErrorHandler.handleFailure(e)` | Converts to `Failure`, returns `Left(failure)` |

```dart
// RemoteDs
} catch (e) {
  ErrorHandler.handleException(e);  // always — do not throw raw
}

// RepoImpl
} catch (e) {
  return Left(ErrorHandler.handleFailure(e));
}
```

### 3. Auth token injection

`AuthInterceptor` (in `DioFactory`) reads the token from `SecureStorage` automatically on every request.  
**Never pass the token manually** in headers or body.  
Token key: `AppConstants.accessTokenKey = 'access_token'`

### 4. AuthCubit is a LazySingleton

`AuthCubit` is registered as `LazySingleton` — there is exactly **one instance** for the entire app lifetime.

```dart
// ✅ Always source from getIt — never construct directly
BlocProvider.value(value: getIt<AuthCubit>(), child: SomeScreen())

// ✅ If a screen needs its own isolated auth cubit (e.g. ResetPasswordScreen)
BlocProvider(create: (_) => getIt<AuthCubit>(), child: ResetPasswordScreen())

// ❌ Never do this
BlocProvider(create: (_) => AuthCubit(repo: ...), child: ...)
```

### 5. AuthState API

```dart
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

state.status == AuthStatus.loading   // ← always use this
state.isLoading                      // shorthand getter (same thing)
state.isAuthenticated                // shorthand getter
state.user                           // UserModel? — null when unauthenticated
state.error                          // String? — null when no error
```

**AuthCubit methods:**
```dart
checkAuth()                    // called once at startup — validates stored token
login(email, password)
signup(name, email, password, passwordConfirm)
getMe()                        // re-fetch current user
updateMe(Map<String, dynamic>) // patch user fields (name, photo, etc.)
logout()
resetPassword(resetToken, password, passwordConfirm)
deleteAccount()
```

### 6. Navigation above the bottom nav bar

To push a screen that covers all 5 tabs (e.g. flight details, profile):
```dart
Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(builder: (_) => TargetScreen()),
);
```
For named routes (preferred):
```dart
context.pushNamed(Routes.profile);
context.pushNamed(Routes.trackedFlight, arguments: {'flightNo': 'MS804', ...});
```

---

## Color System

### Two sources, one rule

| Use | When |
|---|---|
| `context.customColors.*` | Any color that must flip between light ↔ dark mode |
| `AppColors.*` | Brand/status colors that are **identical** in both themes (or on forced-dark surfaces) |

### `CustomColors` semantic tokens — always use these in widgets

```dart
final colors = context.customColors;  // in build()

// Text
colors.textPrimary       // black ↔ white
colors.textSecondary     // grey600 ↔ grey300
colors.textHint          // grey400 ↔ grey500
colors.textDisabled      // grey300 ↔ grey600
colors.textInverse       // white ↔ black (text ON a dark/primary background)

// Background
colors.background        // backgroundLight ↔ backgroundDark  (use for Scaffold)
colors.backgroundSecondary  // grey50 ↔ grey800  (cards, bottom sheets)
colors.backgroundInverse // black ↔ white

// Surface
colors.surface           // white ↔ grey800  (cards, dialogs)
colors.surfaceVariant    // grey100 ↔ grey700  (input fills, skeletons)

// Border & Divider
colors.border            // grey200 ↔ grey600
colors.divider           // grey100 ↔ grey700

// Icon
colors.iconPrimary       // grey700 ↔ grey200
colors.iconSecondary     // grey400 ↔ grey500

// Status
colors.success / .error / .warning / .info
colors.successBackground / .errorBackground / .warningBackground / .infoBackground
```

### `AppColors` static brand palette (no context needed)

```dart
AppColors.primary200    // #002D6B — main navy (headers, buttons, FAB)
AppColors.primary300    // darker navy (pressed states)
AppColors.primary50     // light blue tint (icon bg on light screens)
AppColors.secondary200  // #EDB046 — main gold (accents, highlights)
AppColors.red200        // #ef4444 — error / destructive
AppColors.green200      // #22c55e — success
AppColors.amber200      // #f59e0b — warning
AppColors.blue200       // #3b82f6 — info
AppColors.white         // use ONLY when the background is always dark/primary
AppColors.primaryGradient  // navy gradient — for header cards
```

### Widget patterns

```dart
// Scaffold
Scaffold(backgroundColor: colors.background, ...)

// Card / Container
Container(color: colors.surface, ...)

// Modal bottom sheet — must set backgroundColor explicitly
showModalBottomSheet(
  context: context,
  backgroundColor: colors.surface,
  builder: (_) => ...,
)

// Divider
Divider(color: colors.divider)

// Text style override
Text('...', style: style.copyWith(color: colors.textPrimary))
```

---

## API Endpoints Reference

All constants live in `lib/core/api/api_endpoints.dart`.

**Base URLs:**
- Dev: `http://localhost:3001/api/v1`
- Prod: `https://gate-buddy-backend-production.up.railway.app/api/v1`

**Auth:** Bearer JWT — `Authorization: Bearer {token}` (injected automatically by `AuthInterceptor`)  
**Rate limit:** 100 req / 15 min  
**Response format:** JSend

```json
// Success
{ "status": "success", "data": { } }
// Fail (client error)
{ "status": "fail", "message": "...", "statusCode": 400 }
// Error (server error)
{ "status": "error", "message": "...", "statusCode": 500 }
```

### Auth & Users (🔐 = requires Bearer token)

| Method | Path | Auth | Request body / Notes |
|--------|------|------|----------------------|
| POST | `/users/signup` | ❌ | `{ name, email, password, passwordConfirm }` — returns JWT |
| POST | `/users/login` | ❌ | `{ email, password }` — returns JWT |
| POST | `/users/logout` | 🔐 | Invalidates session |
| POST | `/users/refreshToken` | ❌ | `{ refreshToken }` — returns new access token |
| POST | `/users/oauth` | ❌ | `{ provider: "google"\|"github"\|"facebook", idToken }` |
| GET | `/users/me` | 🔐 | Returns `{ data: { user: {...} } }` |
| PATCH | `/users/updateMe` | 🔐 | `{ name?, photo? }` |
| PATCH | `/users/updatePassword` | 🔐 | `{ passwordCurrent, password, passwordConfirm }` |
| DELETE | `/users/deleteMe` | 🔐 | Soft-delete current user |
| POST | `/users/forgotPassword` | ❌ | Sends reset email |
| POST | `/users/resetPassword` | ❌ | Resets password with token |

### Flights ✈️

> **Note:** Flight times are shifted +6h for testing. Flights auto-expire 1h after scheduled departure (TTL).

| Method | Path | Auth | Notes |
|--------|------|------|-------|
| GET | `/flights` | 🔐 | Query: `limit`, `page`, `departure`, `status` |
| GET | `/flights/search` | 🔐 | Query: `departure`, `arrival`, `date` (YYYY-MM-DD) |
| POST | `/flights/filter` | 🔐 | Body: `{ filters: { status, delayMin, delayMax, gates[] } }` |
| POST | `/flights/:id/track` | 🔐 | Body: `{ boardingPassNumber }` |
| GET | `/flights/:id/updates` | 🔐 | Audit trail — query: `limit` |
| POST | `/flights/scanBoardingPass` | 🔐 | Body: `{ boardingPassData }` — auto-tracks flight |

**Flight status values:** `scheduled` | `boarding` | `delayed` | `departed` | `landed` | `cancelled`

### Services 🏢

| Method | Path | Auth | Notes |
|--------|------|------|-------|
| GET | `/services` | 🔐 | Query: `airport`, `type`, `minRating`, `limit` |
| GET | `/services/:id` | 🔐 | Query: `includeReviews=true` for reviews |
| POST | `/services/search` | 🔐 | Body: `{ query, airport?, type? }` |
| POST | `/services/filter` | 🔐 | Body: `{ filters: { type, minRating, priceLevel[], airport, cuisine[], hasWifi, hasUSB } }` |
| POST | `/services/:id/rate` | 🔐 | Body: `{ rating: 1-5, review? }` |

**Service type values:** `restaurant` | `lounge` | `shop` | `pharmacy` | `bank` | `prayer_room` | `accessibility`

### Notifications 🔔

| Method | Path | Auth | Notes |
|--------|------|------|-------|
| GET | `/notifications` | 🔐 | Query: `limit`, `unreadOnly`, `type` (`flight_update`\|`service_alert`\|`general`) |
| PATCH | `/notifications/:id` | 🔐 | Body: `{ read: true }` |

### Other

| Method | Path | Auth | Notes |
|--------|------|------|-------|
| GET | `/chat/query` | 🔐 | AI assistant query |
| GET | `/places` | 🔐 | Explore places |
| GET | `/search` | 🔐 | Global search — query: `q` |
| GET | `/stats/dashboard` | 🔐 (admin) | System-wide stats |

---

## Features Status

| Feature | API status | Notes |
|---|---|---|
| Auth — login / signup / forgot / reset | ✅ wired | Full flow working |
| Auth — `updatePassword` | ⚠️ not wired | `PATCH /users/updatePassword` exists — add to profile settings |
| Auth — `refreshToken` | ⚠️ not wired | `POST /users/refreshToken` — no auto-refresh interceptor yet |
| Auth — OAuth | ⚠️ not wired | `POST /users/oauth` exists — not implemented |
| Flights list + filter | ✅ wired | `GET /flights` + `POST /flights/filter`, pagination via `page` + `limit` |
| Flights search | ✅ wired | `GET /flights/search?departure=&arrival=&date=` |
| Flight tracking | ⚠️ stub | `POST /flights/:id/track` + `POST /flights/scanBoardingPass` exist — not wired |
| Flight updates audit | ⚠️ not wired | `GET /flights/:id/updates` — not wired |
| Explore Places | ✅ wired | `GET /places` |
| Indoor Map / Services | ✅ wired | `GET /services` with category filter |
| Services search + filter | ⚠️ not wired | `POST /services/search` + `POST /services/filter` endpoints available |
| Services rating | ⚠️ not wired | `POST /services/:id/rate` available |
| AI Assistant | ✅ wired | `GET /chat/query` |
| Home dashboard | ⚠️ mock data | No `/home` endpoint — `HomeCubit` returns hardcoded data |
| Notifications | ⚠️ stub | `GET /notifications` + `PATCH /notifications/:id` — not wired |
| Search | ⚠️ stub | `GET /search?q=` exists — `SearchCubit` not wired |
| Profile (view + update name/photo) | ✅ wired | Uses `AuthCubit.updateMe()` → `PATCH /users/updateMe` |
| Settings (theme/locale) | ✅ wired | Persisted via `HydratedBloc` |

---

## AppSettingsCubit (theme + locale)

```dart
// Read current state
state.themeMode     // ThemeMode.light / dark / system
state.locale        // Locale('en') or Locale('ar')
state.isDarkMode    // bool
state.isArabic      // bool

// Dispatch
context.read<AppSettingsCubit>().toggleTheme();
context.read<AppSettingsCubit>().toggleLocale(context);
context.read<AppSettingsCubit>().updateTheme(ThemeMode.dark);
context.read<AppSettingsCubit>().updateLocale(context, const Locale('ar'));
```

Persisted automatically across app restarts via `HydratedBloc`.

---

## Startup / Routing

```
main_dev.dart / main_prod.dart
  → setUpDependencies()
  → GateBuddyApp
      → AppSettingsCubit (HydratedBloc — restores theme/locale)
      → AuthCubit.checkAuth()
          authenticated   → MainScaffold (5-tab bottom nav)
          unauthenticated → OnboardingScreen → Login
```

Named routes are strings in `lib/core/router/routes.dart`.  
All route arguments are passed as `Map<String, dynamic>` and unpacked in `AppRouter.generateRoute`.

```dart
// Pass arguments
context.pushNamed(Routes.trackedFlight, arguments: {
  'flightNo': 'MS804', 'airline': 'EgyptAir', 'status': 'Boarding',
  'gate': 'A12', 'time': '10:30', 'date': '2026-06-25',
  'from': 'CAI', 'to': 'DXB', 'terminal': 'T1',
});
```

---

## DI Registration Summary

```dart
// ── LazySingleton (shared, created once) ──
InternetConnectionChecker
FlutterSecureStorage → SecureStorage
NetworkInfo
Dio (configured via DioFactory with AuthInterceptor)
ApiConsumer (DioConsumer)

AuthRemoteDs, AuthRepo, AuthCubit
AssistantRemoteDs (ai chat), AssistantRepo, AssistantCubit
IndoorMapRemoteDs, IndoorMapRepo, IndoorMapCubit
ExplorePlacesRemoteDs, ExplorePlacesRepoImpl, ExploreCubit
FlightsRemoteDs, FlightsRepo

// ── Factory (new instance per registration call) ──
FlightsCubit
ForgetPasswordCubit, VerifyCodeCubit
NotificationsCubit  (stub)
ServicesCubit       (stub)
ProfileCubit        (stub — profile screen reads AuthCubit directly)
SearchCubit         (stub)
TrackedFlightCubit  (stub)
```

---

## Common Code Templates

### RemoteDs

```dart
class FeatureRemoteDs {
  final ApiConsumer api;
  FeatureRemoteDs({required this.api});

  Future<SomeModel> fetchSomething() async {
    try {
      final response = await api.get(ApiEndpoints.someEndpoint) as Map<String, dynamic>;
      // If backend wraps in { data: { ... } }:
      final data = response['data'] as Map<String, dynamic>;
      return SomeModel.fromJson(data);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
```

### RepoImpl

```dart
class FeatureRepoImpl implements FeatureRepo {
  final FeatureRemoteDs remoteDs;
  FeatureRepoImpl({required this.remoteDs});

  @override
  Future<Either<Failure, SomeModel>> fetchSomething() async {
    try {
      final result = await remoteDs.fetchSomething();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }
}
```

### Cubit

```dart
class FeatureCubit extends Cubit<FeatureState> {
  final FeatureRepo repo;
  FeatureCubit({required this.repo}) : super(const FeatureInitial());

  Future<void> load() async {
    emit(const FeatureLoading());
    final result = await repo.fetchSomething();
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data)    => emit(FeatureLoaded(data)),
    );
  }
}
```

### Providing a cubit from DI

```dart
// Screen creates its own instance (most common)
BlocProvider(
  create: (_) => getIt<FeatureCubit>(),
  child: const FeatureScreen(),
)

// Screen shares an existing singleton (e.g. AssistantCubit, IndoorMapCubit)
BlocProvider.value(
  value: getIt<FeatureCubit>(),
  child: const FeatureScreen(),
)
```

### Registering in DI

```dart
// In setUpDependencies():
getIt.registerLazySingleton(() => FeatureRemoteDs(api: getIt<ApiConsumer>()));
getIt.registerLazySingleton<FeatureRepo>(() => FeatureRepoImpl(remoteDs: getIt()));
getIt.registerFactory(() => FeatureCubit(repo: getIt<FeatureRepo>()));
```

---

## Exception → Failure Mapping

| HTTP / Cause | Exception | Failure |
|---|---|---|
| 401 | `UnauthorizedException` | `UnauthorizedFailure` |
| 403 | `ForbiddenException` | `ForbiddenFailure` |
| 404 | `NotFoundException` | `NotFoundException` |
| 409 | `ConflictException` | `ConflictFailure` |
| 422 | `ValidationException` | `ValidationFailure` |
| 429 | `TooManyRequestsException` | `TooManyRequestsFailure` |
| Timeout | `TimeoutException` | `TimeoutFailure` |
| No internet | `NetworkException` | `NetworkFailure` |
| Cache issue | `CacheException` | `CacheFailure` |
| 5xx / other | `ServerException` | `ServerFailure` |
| Unknown | — | `UnknownFailure` |

---

## Pending Work

| Item | API endpoint | Priority |
|---|---|---|
| Token refresh interceptor | `POST /users/refreshToken` | High — 401s mid-session |
| Notifications list + mark read | `GET /notifications`, `PATCH /notifications/:id` | High |
| Flight tracking (track + scan) | `POST /flights/:id/track`, `POST /flights/scanBoardingPass` | High |
| Search | `GET /search?q=` | Medium |
| Services search + filter | `POST /services/search`, `POST /services/filter` | Medium |
| Services rating | `POST /services/:id/rate` | Medium |
| Change password in profile settings | `PATCH /users/updatePassword` | Medium |
| Flight updates audit trail | `GET /flights/:id/updates` | Low |
| OAuth login | `POST /users/oauth` | Low |
| Home dashboard | No backend endpoint — decide on design | Low |
| Profile stats row | Wire Tracked/Flights/Alerts counts when above features done | Low |
| Remove `ProfileCubit` stub from DI | Profile reads `AuthCubit` directly | Low |
| Migrate `lib/data/storage/` | Move files to `lib/core/service/` | Cleanup |
| Phase 3 UI | Waiting for Figma designs | Blocked |
