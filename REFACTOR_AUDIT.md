# GateBuddy — Refactor Audit (Phase 0)

> **Read-only audit. No code was modified.**
> Date: 2026-06-28 | Branch: fix-api-integration

---

## 1. Color Violations

### 1a. Raw `Color(0xFF…)` hex literals in UI files

| File | Snippet |
|---|---|
| `features/home/ui/home_screen.dart` | `static const Color primaryBlue = Color(0xFF013F82)` and `accentOrange = Color(0xFFF3A623)` — should be `AppColors.primary200` / `AppColors.secondary200` |
| `features/home/ui/widgets/home_app_bar.dart` | `static const Color iconGold = Color(0xFFF3A623)` |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | `Color(0xFFE3E7F1)`, `Color(0xFFFDFDFD)`, `Color(0xFFFFF1D4)`, `Color(0xFFC68A2B)`, `Color(0xFF8E5B15)` — all inlined |
| `features/home/ui/widgets/flight_row.dart` | `Color(0xFFFDFDFD)`, `Color(0xFFE3E7F1)`, `Color(0xFF003A72)`, `Color(0xFF004780)`, `Color(0xFFFFF1D4)`, `Color(0xFFC68A2B)`, `Color(0xFF8E5B15)` |
| `features/home/ui/widgets/section_title.dart` | `color: Color(0xFFF3A623)` on dot decoration |
| `features/home/ui/widgets/service_card.dart` | `Color(0xFFE3E7F1)`, `Color(0xFFF3A623)`, `Color(0xFF003A72)` |
| `features/indoor_map/ui/indoor_map_screen.dart` | `_markerColor`: `Color(0xFFEA580C)`, `Color(0xFF7C3AED)`, `Color(0xFF059669)`, `Color(0xFF0284C7)`, `Color(0xFF0891B2)` |
| `features/indoor_map/ui/widgets/service_detail_sheet.dart` | `Color(0xFFEFF3FB)`, `Color(0xFFF9FAFB)`, `Color(0xFFE3E7F1)` |
| `features/indoor_map/ui/widgets/navigation_panel.dart` | `Color(0xFFEFF4FF)`, `Color(0xFF1A1A2E)` |
| `features/indoor_map/ui/widgets/map_category_filter.dart` | `Color(0xFFE3E7F1)` |
| `features/explore_places/ui/widgets/search_field.dart` | `Color(0xFFD4A843)`, `Color(0xFFC47E3A)` |

### 1b. `Colors.xxx` / `Colors.grey.shadeN` used instead of `context.customColors.*`

| File | Examples |
|---|---|
| `features/home/ui/home_screen.dart` | `CircularProgressIndicator(color: Colors.white)`, `TextStyle(color: Colors.white)` |
| `features/home/ui/widgets/home_app_bar.dart` | `TextStyle(color: Colors.white, ...)` |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | `Colors.white`, `Colors.grey.shade800` |
| `features/home/ui/widgets/updated_flights_section.dart` | `Colors.grey.shade700`, `Colors.white`, `Colors.black.withOpacity(0.04)`, `Colors.orange.shade600` |
| `features/home/ui/widgets/flight_row.dart` | `Colors.white` (containers + text), plus raw status-chip colors |
| `features/home/ui/widgets/service_card.dart` | `color: Colors.white` |
| `features/indoor_map/ui/indoor_map_screen.dart` | `Colors.white` marker, app bar, legend; `Colors.black.withValues(...)` shadow |
| `features/indoor_map/ui/widgets/service_detail_sheet.dart` | `Colors.white`, `Colors.grey.shade{100,300,600,700}`, `Colors.green.shade{500,600}`, `Colors.red.shade{400,500}` |
| `features/indoor_map/ui/widgets/navigation_panel.dart` | `Colors.white`, `Colors.grey.shade{200,400,500,600}`, `Colors.green.shade400` |
| `features/indoor_map/ui/widgets/map_category_filter.dart` | `Colors.white`, `Colors.grey.shade{600,700}` |
| `features/explore_places/ui/widgets/search_field.dart` | `Colors.white`, `Colors.grey.shade400` |
| `features/explore_places/ui/place_details_screens.dart` | `Colors.black.withValues(alpha: 0.35)` |

---

## 2. Text Style Violations

Inline `TextStyle(…)` in widget `build` methods — should be `AppTextStyles.*` tokens or `Theme.of(context).textTheme.*`.

| File | Scope of violations |
|---|---|
| `features/home/ui/home_screen.dart` | `_errorView`, `_loadedView` section headers |
| `features/home/ui/widgets/home_app_bar.dart` | App-bar title style |
| `features/home/ui/widgets/section_title.dart` | Title text style hardcoded inline |
| `features/home/ui/widgets/updated_flights_section.dart` | Header, subtitle, "View All", status badge |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | Airline name, flight no, time, status, button labels |
| `features/home/ui/widgets/flight_row.dart` | Flight no, route labels, before/after labels, status chip, RichText spans |
| `features/home/ui/widgets/service_card.dart` | Service name label |
| `features/indoor_map/ui/indoor_map_screen.dart` | `_buildAppBar` title + subtitle; `_buildLegend` labels |
| `features/indoor_map/ui/widgets/service_detail_sheet.dart` | Name, category badge, open/closed, rating, description, amenities |
| `features/indoor_map/ui/widgets/navigation_panel.dart` | Destination name, step count, step instructions, distance |
| `features/indoor_map/ui/widgets/map_category_filter.dart` | Category chip labels |
| `features/explore_places/ui/explore_places_screen.dart` | Header title/subtitle, section headers, empty state, error state, all sub-labels |
| `features/explore_places/ui/widgets/place_card.dart` | Name, category, terminal, rating, price |
| `features/explore_places/ui/widgets/featured_place_card.dart` | Name, terminal, category |
| `features/explore_places/ui/widgets/search_field.dart` | Hint text style |
| `features/explore_places/ui/place_details_screens.dart` | Throughout detail view |
| `features/ai_chat/ui/widgets/message_bubble.dart` | Message text, timestamp |
| `features/ai_chat/ui/widgets/assistant_app_bar.dart` | Title, status dot label |
| `features/ai_chat/ui/widgets/typing_indicator.dart` | Typing label |
| `features/flights/ui/widgets/flight_card.dart` | Flight no, route, status badge, time labels, track button |

---

## 3. Sizing Violations

**Root cause:** Nearly all files outside `explore_places` and `flights` card use raw pixel constants instead of ScreenUtil extensions (`.w`, `.h`, `.r`, `.sp`). Design base is 375×812.

### 3a. `SizedBox` / `Container` without `.h` / `.w`

| Feature area | Examples |
|---|---|
| `features/auth/ui/login_screen.dart` | `SizedBox(height: 8/16/4/28/24)` throughout |
| `features/auth/ui/signup_screen.dart` | `SizedBox(height: 8/16/28/24)` throughout |
| `features/auth/ui/forget_password_screen.dart` | `SizedBox(height: 8/32/28/24)` |
| `features/auth/ui/get_code_screen.dart` | `SizedBox(height: 8/24/32/12/56)`, `SizedBox(width: 48/8)` (OTP boxes) |
| `features/auth/ui/reset_password_screen.dart` | `SizedBox(height: 8/32/16/28/24)` |
| `features/auth/ui/widgets/auth_header.dart` | `SizedBox(height: 24/20/6)`, `SizedBox(width: 10)` |
| `features/auth/ui/widgets/auth_primary_button.dart` | `SizedBox(width: double.infinity, height: 54)`, `SizedBox(width: 22, height: 22)` |
| `features/home/ui/home_screen.dart` | `SizedBox(height: 24/10)` |
| `features/home/ui/widgets/home_app_bar.dart` | `Container(height: 60)` |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | `SizedBox(height: 10/16/4/10)`, `SizedBox(width: 8/44/42)` |
| `features/home/ui/widgets/section_title.dart` | `SizedBox(width: 6)` |
| `features/home/ui/widgets/service_card.dart` | `Container(height: 64)`, `SizedBox(width: 8)` |
| `features/home/ui/widgets/flight_row.dart` | `SizedBox(height: 4)`, `Container(height: 18)`, `SizedBox(width: 8/6)` |
| `features/indoor_map/ui/indoor_map_screen.dart` | `Container(height: 56)` app bar; `EdgeInsets.all(60/9/24/12/16)` |
| `features/indoor_map/ui/widgets/service_detail_sheet.dart` | All `EdgeInsets` and `SizedBox` raw |
| `features/indoor_map/ui/widgets/navigation_panel.dart` | All `EdgeInsets` and `SizedBox` raw |
| `features/indoor_map/ui/widgets/map_category_filter.dart` | All padding raw |
| `features/profile/ui/profile_screen.dart` | All `EdgeInsets` and `SizedBox` raw |
| `features/profile/ui/widgets/profile_section.dart` | All `EdgeInsets` raw |
| `features/profile/ui/widgets/edit_profile_sheet.dart` | `EdgeInsets.fromLTRB(24, 24, 24, bottom+24)`, `SizedBox(height: 24)`, `SizedBox(width: 20, height: 20)` |
| `features/ai_chat/ui/ai_chat_screen.dart` | `SizedBox(width: 80, height: 80/16/8)` |
| `features/ai_chat/ui/widgets/message_bubble.dart` | `EdgeInsets.only(bottom: 12)`, `SizedBox(width: 32, height: 32/8)` |
| `features/ai_chat/ui/widgets/input_bar.dart` | `EdgeInsets.symmetric(horizontal: 16, vertical: 10)`, `SizedBox(width: 44, height: 44/10)` |
| `features/ai_chat/ui/widgets/assistant_app_bar.dart` | `SizedBox(width: 40, height: 40/12/7/5)` |
| `features/ai_chat/ui/widgets/typing_indicator.dart` | `SizedBox(width: 32, height: 32/8)` |
| `features/flights/ui/widgets/flight_card.dart` | Nearly all spacing raw: `SizedBox(width: 10/8/6/4)`, `SizedBox(height: 14/12/10/2)` |
| `features/flights/ui/flights_screen.dart` | `EdgeInsets.symmetric(horizontal: 16, vertical: 14)` |

### 3b. `BorderRadius.circular(N)` without `.r`

Pervasive in auth, home, indoor_map, profile, ai_chat, flights. Examples:
- `BorderRadius.circular(20)` — navigation panel / service detail sheet
- `BorderRadius.circular(14)` — profile cards, flight cards
- `BorderRadius.circular(24)` — input bar
- `BorderRadius.circular(12)` — home widgets

---

## 4. Hardcoded User-Visible Strings (no `.tr()`)

Only the `onboarding.*` and a handful of `errors.*` keys are localized. The entire app below onboarding is untranslated.

| Feature | Hardcoded strings (sample) |
|---|---|
| `features/auth/ui/login_screen.dart` | `'Welcome Back'`, `'Sign in to continue your journey'`, `'Email'`, `'Password'`, `'Forgot password?'`, `'Log In'`, `"Don't have an account?"`, `'Sign Up'` |
| `features/auth/ui/signup_screen.dart` | `'Create Account'`, `'Join GateBuddy to track your flights'`, `'Full Name'`, `'Confirm Password'`, `'Already have an account?'` |
| `features/auth/ui/forget_password_screen.dart` | `'Forgot Password?'`, `"Enter your email and we'll send a reset code"`, `'Send Reset Code'`, `'Back to Login'` |
| `features/auth/ui/get_code_screen.dart` | `'Enter Reset Code'`, `'Check your email for the 6-digit code'`, `'Please enter all 6 digits'`, `"Didn't receive the code?"`, `'Resend'`, `'Verify Code'`, `'Code resent successfully'` |
| `features/auth/ui/reset_password_screen.dart` | `'Reset Password'`, `'Create a new secure password'`, `'New Password'`, `'Confirm New Password'` |
| `features/home/ui/home_screen.dart` | `'Your Tracked Flight'`, `'Airport Services'`, `'❌ Error: $error'` |
| `features/home/ui/widgets/home_app_bar.dart` | `'Gate buddy'` |
| `features/home/ui/widgets/updated_flights_section.dart` | `'Updated Flights ✈️'`, `'Stay informed about the latest flight and gate changes.'`, `'View All'` |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | `'Flight No: $flightNo'`, `'Explore Destination'`, `'Cancel Tracking'` |
| `features/home/ui/widgets/flight_row.dart` | `'Before: '`, `'After: '`, hardcoded `'Departure 10:30 AM'`, `'Gate B12'` (mock data in UI) |
| `features/flights/ui/flights_screen.dart` | `'Flights'`, `'No results for "…"'`, `'No departure flights available'`, `'No arrival flights available'` |
| `features/flights/ui/widgets/custom_tab_bar.dart` | `'Departure'`, `'Arrival'` |
| `features/flights/ui/widgets/search_field.dart` | `hintText: 'Search by flight number, airline...'` |
| `features/explore_places/ui/explore_places_screen.dart` | `'Explore Airport'`, `'Discover services & places'`, `'No places found'`, `'Try a different search or category'`, `'Retry'`, `'All Services'`, category label strings |
| `features/explore_places/ui/widgets/search_field.dart` | `hintText: 'Search by name or category...'` |
| `features/indoor_map/ui/indoor_map_screen.dart` | `'Indoor Map'`, `'Navigation active'`, `'N services nearby'` |
| `features/indoor_map/ui/widgets/service_detail_sheet.dart` | `'Open Now'`, `'Closed'`, `'Navigate'`, `'Gate N'`, `'Zone N'`, `'Terminal N'`, `'N min wait'` |
| `features/indoor_map/ui/widgets/navigation_panel.dart` | `'Navigating to ${dest.name}'`, `'N / N steps'` |
| `features/profile/ui/profile_screen.dart` | `'Profile'`, `'Edit'`, `"You're not logged in"`, `'Log In'`, `'Dark Mode'`, `'Language'`, `'Arabic'`/`'English'`, `'Log Out'`, `'Delete Account'`, `'Are you sure you want to log out?'`, `'This action is irreversible...'`, `'Tracked'`, `'Flights'`, `'Alerts'`, `'Version 1.0.0'` — 30+ strings |
| `features/profile/ui/widgets/edit_profile_sheet.dart` | `'Edit Profile'`, `'Full Name'`, `'Save Changes'`, `'Profile updated'` |
| `features/ai_chat/ui/ai_chat_screen.dart` | `'Log in to chat with GateBuddy'`, `"Hi! I'm GateBuddy ✈️"`, `'Ask me anything about your flight...'`, `'Login Required'` |
| `features/ai_chat/ui/widgets/input_bar.dart` | `hintText: 'Ask GateBuddy anything...'` |
| `features/notifications/ui/notifications_screen.dart` | `'Notifications — coming soon'` |
| `features/tracked_flight/ui/tracked_flight_screen.dart` | `'Tracked Flight — coming soon'` |

---

## 5. Asset Path Violations

| File | Violation |
|---|---|
| `features/on_boarding/ui/onboarding_screen.dart` | `'assets/images/on_boarding_1.png'`, `'assets/images/on_boarding_2.png'`, `'assets/images/on_boarding_3.png'` — raw string literals; `AppAssets` class exists at `lib/core/utils/app_assets.dart` and must be used |

---

## 6. Navigation Violations

Should use `context.pushNamed(Routes.xxx)` (from `context_ext.dart`). Direct `Navigator` calls:

| File | Violation |
|---|---|
| `features/auth/ui/login_screen.dart` | `Navigator.pushNamed(context, Routes.forgetPassword)` and `Routes.signup` |
| `features/auth/ui/forget_password_screen.dart` | `Navigator.push(context, MaterialPageRoute(builder: (_) => GetCodeScreen(...)))` — bypasses `AppRouter` entirely, loses slide transition |
| `features/auth/ui/get_code_screen.dart` | `Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen(...)))` — same, bypasses `AppRouter` |
| `features/home/ui/widgets/home_app_bar.dart` | `Navigator.pushNamed(context, Routes.search)` and `Navigator.of(context, rootNavigator: true).pushNamed(Routes.profile)` |
| `features/home/ui/widgets/tracked_flight_big_card.dart` | `Navigator.push(context, MaterialPageRoute(builder: (_) => TrackedFlightScreen(...)))` |
| `features/home/ui/widgets/flight_row.dart` | `Navigator.push(context, MaterialPageRoute(builder: (_) => TrackedFlightScreen(...)))` |
| `features/ai_chat/ui/ai_chat_screen.dart` | `Navigator.pushNamed(context, Routes.login)` in auth banner and dialog |
| `features/profile/ui/profile_screen.dart` | `Navigator.pushNamed(context, Routes.forgetPassword/trackedFlight/notifications/login)` |

`forget_password_screen.dart` and `get_code_screen.dart` are the most severe: they use `MaterialPageRoute` which completely bypasses `AppRouter`, losing named-route slide transitions and type safety.

---

## 7. Error Handling Inconsistencies

### RemoteDs layer — no `try/catch` / `ErrorHandler.handleException`

| File | Issue |
|---|---|
| `features/notifications/data/remote/notifications_remote_ds.dart` | Bare `api.get/patch(...)` — uncaught exceptions propagate as raw `DioException` |
| `features/profile/data/remote/profile_remote_ds.dart` | All 4 methods: bare API calls, no error wrapping |
| `features/home/data/remote/home_remote_ds.dart` | Bare `api.get(ApiEndpoints.home)` |

### RepoImpl layer — no `ErrorHandler.handleFailure` conversion

| File | Issue |
|---|---|
| `features/flights/data/repo/flights_repo_impl.dart` | Every method is a one-liner pass-through to `remoteDs.*` with no try/catch. Exceptions are `AppException` (not `Failure`) — cubits receive the wrong type |
| `features/home/data/repo/home_repo_impl.dart` | Pass-through, no failure conversion |
| `features/ai_chat/data/repo/ai_chat_repo_impl.dart` | `sendMessage` delegates directly with no error handling; repo layer adds zero value |
| `features/auth/data/repo/auth_repo_impl.dart` | `logout()` uses broad `catch (_)` — silently swallows all errors |

### Cubit layer — raw `e.toString()` instead of `Failure.message`

| File | Issue |
|---|---|
| `features/flights/logic/cubit/flights_cubit.dart` | `catch (e)` then `e.toString()` for error state — not `ErrorHandler.handleFailure(e)` |
| `features/indoor_map/logic/cubit/indoor_map_cubit.dart` | Same: `emit(IndoorMapError(e.toString()))` |
| `features/ai_chat/logic/cubit/ai_chat_cubit.dart` | Checks `e is Failure` then falls back — partially correct but unreliable because `AssistantRepoImpl` never throws a `Failure` |

---

## 8. Duplicated Widgets

### 8a. Search input — 3 separate implementations

1. `features/flights/ui/widgets/search_field.dart` — uses `AppTextStyles`, `AppColors`
2. `features/explore_places/ui/widgets/search_field.dart` — completely different, uses raw `Color(0xFFD4A843)` and `Colors.white`
3. `features/explore_places/ui/explore_places_screen.dart` — third inline `TextField` inside `_buildHeader` / `AnimatedSize`

No shared `core/widgets/core_search_field.dart` exists.

### 8b. Loading spinners — 8+ unshared inline uses

`CircularProgressIndicator` inlined in:
- `features/home/ui/home_screen.dart` (`_loadingView`)
- `features/explore_places/ui/explore_places_screen.dart` (`_buildLoading`)
- `features/indoor_map/ui/indoor_map_screen.dart` (bottom-area loading)
- `features/flights/ui/widgets/flight_card.dart` (`_TrackButton`)
- `features/auth/ui/widgets/auth_primary_button.dart` (loading state)
- `features/profile/ui/widgets/edit_profile_sheet.dart` (save button)
- More in AI chat

`core/widgets/ui/loaders/overlay_loader.dart` exists but is barely used.

### 8c. Empty-state widgets — each feature re-implements its own

- `features/explore_places/ui/explore_places_screen.dart` (`_buildEmpty`)
- `features/indoor_map/ui/indoor_map_screen.dart` (no-data state)
- `features/flights/ui/` (separate implementation)

No `core/widgets/empty_state.dart`.

### 8d. Error+Retry widgets — each feature re-implements its own

- `features/explore_places/ui/explore_places_screen.dart` (`_buildError`)
- `features/indoor_map/ui/indoor_map_screen.dart` (error container in `_buildBottomArea`)
- `core/widgets/error_screen.dart` — exists but uses two localization keys missing from both lang files (see Section 9)

### 8e. Card: image + title + subtitle pattern

`PlaceCard` (explore_places) and service detail cards (indoor_map) follow identical structure but are completely separate with duplicated styling logic.

---

## 9. Missing Localization Keys

### Keys used in code but absent from both `en.json` and `ar.json`

| Key used in code | File | Status |
|---|---|---|
| `'errors.error_screen_desc'` | `core/widgets/error_screen.dart` | **Missing from both files** |
| `'errors.error_screen_button'` | `core/widgets/error_screen.dart` | **Missing from both files** |

### Keys that should exist but don't (hardcoded strings per Section 4)

The lang files contain only `app_title`, `welcome`, `errors.*`, `about.*`, and `onboarding.*`. Every string in auth, home, flights, explore, indoor map, profile, and AI chat features (100+ strings total) has no corresponding localization key.

---

## 10. SOLID Violations

### 10a. Business logic embedded in UI (`home_screen.dart`)

`features/home/ui/home_screen.dart` — `_loadedView` casts `state.data` inline:
```dart
List<Map<String, dynamic>>.from(data["updatedFlights"] ?? [])
data["trackedFlight"] as Map<String, dynamic>?
```
JSON mapping is the data layer's responsibility, not the widget's.

### 10b. Mock data in the Cubit (`home_cubit.dart`)

`features/home/logic/cubit/home_cubit.dart` emits a hardcoded full mock JSON object directly from the cubit. Mock data belongs in a `FakeRemoteDs` or `dev` data layer, not the cubit.

### 10c. Repo layer adds zero value — `FlightsRepoImpl` and `AssistantRepoImpl`

- `features/flights/data/repo/flights_repo_impl.dart` — every method is a one-liner delegation with no error conversion. Repos must convert `AppException` → `Failure` for the cubit contract.
- `features/ai_chat/data/repo/ai_chat_repo_impl.dart` — same pattern: direct pass-through, no `ErrorHandler.handleFailure`.

### 10d. `ResetPasswordScreen` bypasses DI for `AuthCubit`

`features/auth/ui/reset_password_screen.dart`:
```dart
BlocProvider(
  create: (_) => AuthCubit(repo: getIt()),  // constructs directly, not getIt<AuthCubit>()
  ...
)
```
`AuthCubit` is registered as `LazySingleton`. Constructing it manually creates a second, unregistered instance that bypasses the DI registry.

### 10e. `HomeRepo` abstract interface returns `dynamic`

`features/home/data/repo/home_repo.dart` — `getHomeData()` returns `Future<dynamic>`. Not type-safe; defeats the purpose of an abstract interface.

### 10f. `flight_row.dart` hardcodes business data in presentation layer

`features/home/ui/widgets/flight_row.dart` contains hardcoded strings `'Departure 10:30 AM'`, `'Gate B12'`, `'Gate C7'` and index-based conditionals that emulate business rules. Presentation layer must not contain business data.

---

## Priority Hotlist — Top 10 Most Impactful Fixes

| # | Fix | Impact | Files |
|---|---|---|---|
| **1** | **Wire error handling in all RemoteDs / RepoImpl layers** — add `try/catch` + `ErrorHandler.handleException/handleFailure` everywhere it's missing | Prevents silent crashes in Notifications, Profile, Home, Flights, AI Chat in production | `notifications_remote_ds.dart`, `profile_remote_ds.dart`, `home_remote_ds.dart`, `flights_repo_impl.dart`, `ai_chat_repo_impl.dart` |
| **2** | **Fix auth navigation to use `AppRouter`** — replace `MaterialPageRoute` in `forget_password_screen.dart` and `get_code_screen.dart` with `context.pushNamed(Routes.xxx)` | Auth flow bypasses AppRouter today; transitions and argument passing break if routes ever need arguments | `forget_password_screen.dart`, `get_code_screen.dart` |
| **3** | **Add missing localization keys** (`errors.error_screen_desc`, `errors.error_screen_button`) and begin populating `en.json` / `ar.json` for auth strings | `error_screen.dart` crashes with a missing-key exception on error routes right now | `assets/lang/en.json`, `assets/lang/ar.json`, auth screen files |
| **4** | **Replace `ResetPasswordScreen`'s manual `AuthCubit(repo: getIt())`** with `getIt<AuthCubit>()` | Creates a second, unregistered AuthCubit instance — auth state won't sync with the root AuthCubit listener | `reset_password_screen.dart` |
| **5** | **Fix Home feature color/style violations** — replace `static const Color primaryBlue/accentOrange` and all raw `Colors.*` in `home_screen.dart`, `home_app_bar.dart`, `flight_row.dart`, `tracked_flight_big_card.dart`, `service_card.dart` with `AppColors.*` / `context.customColors.*` | Home is the most-visited screen; violations break dark-mode support entirely | Home widget files |
| **6** | **Extract shared `CoreSearchField` widget** to `core/widgets/` and replace the 3 incompatible search field implementations | Inconsistent UX, duplicated styling, future changes require 3 edits | `features/*/ui/widgets/search_field.dart`, `explore_places_screen.dart` |
| **7** | **Extract shared `EmptyStateWidget` and `ErrorRetryWidget`** to `core/widgets/` | 5+ redundant inline implementations; bugs get fixed in one place and not others | All feature `_buildEmpty` / `_buildError` methods |
| **8** | **Migrate auth screens to ScreenUtil sizing** — replace all raw `SizedBox(height: N)` / `EdgeInsets` with `.h`, `.w`, `.r` | Auth screens look broken on small/large devices (no responsive sizing at all) | All 5 auth screen files and their widgets |
| **9** | **Move `HomeCubit` mock data to a `FakeHomeRemoteDs`** and type-safe `HomeRepo` (replace `Future<dynamic>` return type) | `home_cubit.dart` contains JSON structures that belong in the data layer; makes unit testing impossible | `home_cubit.dart`, `home_repo.dart`, `home_remote_ds.dart` |
| **10** | **Replace all remaining `Navigator.pushNamed` calls with `context.pushNamed`** (home app bar, profile screen, AI chat) | Inconsistent navigation API; argument maps not type-checked; violates project conventions | `home_app_bar.dart`, `profile_screen.dart`, `ai_chat_screen.dart`, `tracked_flight_big_card.dart`, `flight_row.dart` |

---

# Phase 1 — Core Foundation Hardening (COMPLETED)

## Summary of Changes

All changes in Phase 1 were scoped to `lib/core/` — no feature code was modified.

### 1. **AppAssets** (`lib/core/utils/app_assets.dart`)
   - **Before:** Only 2 assets defined (appLogoImage, appLogoSvg)
   - **After:** 8 assets now registered:
     - App branding: `splash`
     - Onboarding: `onboardingPage1`, `onboardingPage2`, `onboardingPage3`
     - Airlines: `egyptAirLogo`
     - Test: `testImage`
   - **Impact:** Onboarding screen can now use `AppAssets.onboardingPage1` instead of raw strings

### 2. **AppColors** (`lib/core/themes/app_colors.dart`)
   - **Status:** Verified complete — all required color shades present
   - **No changes needed** — primary, secondary, grey, red, green, amber, blue all have 4+ shades

### 3. **CustomColors** (`lib/core/themes/custom_colors.dart`)
   - **Status:** Verified complete — all semantic tokens have light/dark variants
   - **Coverage:** text (5 levels), background (3 levels), surface (2 levels), border, divider, icon (2 levels), status (4 × 2 levels)
   - **No changes needed**

### 4. **AppTextStyles** (`lib/core/themes/app_text_styles.dart`)
   - **Status:** Verified complete — consistent naming, all sizes 12–24, weights Light/Regular/Medium/Bold
   - **Coverage:** font12–24, each with 4 weight variants
   - **No changes needed**

### 5. **Spacing helpers** (`lib/core/utils/spacing.dart`)
   - **Before:** Only basic `rw`, `rh`, `rr`, `rf` functions and `verticalSpacing` / `horizontalSpacing` widgets
   - **After:** Added responsive padding/border-radius factories:
     - `responsivePaddingAll(value)` — EdgeInsets.all with `.r`
     - `responsivePaddingSymmetric(h, v)` — horizontal/vertical with `.w` / `.h`
     - `responsivePaddingFromLTRB(l, t, r, b)` — all sides with proper axis scaling
     - `responsiveBorderRadiusAll(radius)` — all corners with `.r`
     - `responsiveBorderRadiusOnly(...)` — individual corners with `.r`
   - **Impact:** Eliminates raw `EdgeInsets` and `BorderRadius` in feature code

### 6. **Extensions** (`lib/core/utils/extensions/context_ext.dart`)
   - **Status:** Verified complete — all required extensions present
   - **Coverage:**
     - Theme: `customColors`, `isDarkMode`
     - MediaQuery: `screenSize`, `screenWidth`, `screenHeight`, `isKeyboardVisible`
     - Locale: `currentLocale`, `isArabic`
     - SnackBar: `hideKeyboard`, `showSnackBar`, `showErrorSnackBar`, `showSuccessSnackBar`
     - Navigation: `push`, `pushReplacement`, `pushAndRemoveAll`, `pop`, `pushNamed`, `pushReplacementNamed`, `pushNamedAndRemoveAll`
   - **No changes needed** — all required APIs present and working

### 7. **Validators** (`lib/core/utils/validators.dart`)
   - **Before:** All error messages hardcoded English strings
   - **After:** All 18 validators now use `.tr()` localization keys:
     - `required`, `email_required`, `email_invalid`
     - `password_required`, `password_min_length`, `password_uppercase`, `password_lowercase`, `password_number`, `password_special_char`
     - `password_confirm_required`, `password_mismatch`
     - `phone_required`, `phone_invalid`
     - `minLength`, `maxLength`, `numeric`
     - `url_required`, `url_invalid`
     - `creditCard_required`, `creditCard_invalid`
     - `date_required`, `date_format`, `date_invalid`, `date_month_invalid`, `date_day_invalid`
   - **Keys added to:** `assets/lang/en.json` and `assets/lang/ar.json` under `validators.*`
   - **Impact:** Validation messages now fully localized for English and Arabic

### 8. **Localization files** (`assets/lang/en.json`, `assets/lang/ar.json`)
   - **Added:** Missing `error_screen_desc` and `error_screen_button` keys (referenced in `core/widgets/error_screen.dart` but absent)
   - **Added:** Full `validators.*` section with 23 keys in both English and Arabic
   - **Impact:** `error_screen.dart` will no longer crash with missing-key exceptions

### 9. **AppConstants** (`lib/core/utils/app_constants.dart`)
   - **Before:** Contained duplicate API config (baseUrl, apiVersion) that belonged in AppConfig
   - **After:** Removed API config duplication; now only contains:
     - Storage keys (6)
     - Pagination (2)
     - Animation durations (3)
     - Spacing (5 values)
     - Border radius (5 values)
     - Icon sizes (4 values)
     - Avatar sizes (4 values)
     - Validation constants (4)
     - File upload (3)
     - Date/time formats (3)
     - Regular expressions (3, kept in sync with Validators)
   - **Removed:** `baseUrl`, `apiVersion`, `connectionTimeout`, `receiveTimeout` — all centralized in `AppConfig`
   - **Impact:** Single source of truth for API config; AppConstants focused on UI/UX constants

## Compilation Status
- **flutter analyze lib/core/:** ✅ No issues found
- **flutter analyze (full project):** ✅ 1 pre-existing issue (withOpacity in home/updated_flights_section.dart — not in Phase 1 scope)

## Next Steps
Phase 1 has hardened the core foundation. Phase 2 should focus on:
1. **Auth screens** — replace raw sizing / colors / text styles with AppAssets, AppColors, AppTextStyles, spacing helpers, and validator localization
2. **Home feature** — same refactor as auth, plus fix navigation to use `context.pushNamed`
3. **Feature-level fixes** — onboarding to use AppAssets, profile to wire validator keys, etc.


---

# Phase 2 — Unified Error Handling (COMPLETED)

## Summary of Changes

All changes in Phase 2 were scoped to `lib/core/errors/` — no feature code was modified.

### 1. **Fixed NotFoundException Shadowing** (`failure.dart`)
   - **Issue:** `exceptions.dart` had `NotFoundException extends AppException` and `failure.dart` had `NotFoundException extends Failure` — naming collision
   - **Fix:** Renamed `failure.dart` class to `NotFoundFailure`
   - **Impact:** Removed need for `hide NotFoundException` workaround in `error_handler.dart`

### 2. **Enhanced AppException** (`exceptions.dart`)
   - **Before:** `toString()` returned only `message`
   - **After:** `toString()` returns both message and HTTP status code: `"$message (HTTP $statusCode)"`
   - **Impact:** Better debugging; developers see the HTTP error code immediately

### 3. **Localized all exception messages** (`exceptions.dart`, `en.json`, `ar.json`)
   - **Before:** Hardcoded English strings in exception defaults (e.g., `message = 'No internet connection'`)
   - **After:** All defaults are localization keys (e.g., `message = 'errors.no_internet'`)
   - **Keys:** `no_internet`, `unauthorized`, `forbidden`, `not_found`, `timeout`, `validation`, `parse_error`, `conflict`, `too_many_requests`
   - **Impact:** Error messages will automatically translate based on locale

### 4. **Single error handler entry point** (`error_handler.dart`)
   - **Before:** Two separate entry points with confusing naming:
     - `handleException(e)` — threw AppException directly from RemoteDs
     - `handleFailure(e)` — converted AppException to Failure (expected by repos)
   - **After:** Clear contract for each layer:
     - `ErrorHandler.handle(e)` — RemoteDs use this (throws `AppException`)
     - `ErrorHandler.handleFailure(e)` — Repos use this (returns `Failure`)
     - `ErrorHandler.handleException(e)` — deprecated but kept for backward compatibility
   - **Impact:** Single source of truth; any error type → AppException → Failure

### 5. **JSend message parsing** (`dio_handler.dart`)
   - **Before:** Used HTTP status message (generic: "Bad Request", "Unauthorized")
   - **After:** Extracts `response.data['message']` if JSend format available, then falls back to `statusMessage`
   - **Code:**
     ```dart
     final message = _extractMessage(response); // JSend extraction
     return _mapByCode(code, message);
     ```
   - **Impact:** Backend error messages now reach the UI instead of generic HTTP descriptions

### 6. **Localized failure messages** (`failure.dart`)
   - **Before:** Hardcoded English strings in Failure defaults
   - **After:** All defaults are localization keys matching exceptions (e.g., `errors.no_internet`)
   - **Impact:** Error messages in cubits automatically translate

### 7. **Updated error handling documentation** (`CLAUDE.md`)
   - **Added:** New "Error Handling" section with:
     - Diagram: `DioException` → `AppException` → `Failure` → UI
     - Code examples for each layer (RemoteDs, Repo, Cubit)
     - Full list of error classes and their purposes
     - Localization requirement: all defaults are keys, never hardcoded strings

## Compilation Status
- **flutter analyze lib/core/errors/:** ✅ No issues found
- **flutter analyze (full project):** ✅ 1 pre-existing issue (withOpacity in home/updated_flights_section.dart — not in Phase 2 scope)

## Error Flow Summary (Post-Phase 2)

```
Network Request (RemoteDs)
           ↓
    DioException
           ↓
  DioHandler.handle(e)
           ↓
    AppException (with localization key message + statusCode)
           ↓
ErrorHandler.handle(e) [throws in RemoteDs]
           ↓
Repo catches AppException
           ↓
ErrorHandler.handleFailure(e) [returns Failure with localization key]
           ↓
Cubit catches AppException or Failure
           ↓
emit(state.copyWith(error: e.message)) 
           ↓
UI renders error with .tr() on the localization key
```

## Next Steps

Phase 3 should focus on:
1. **Auth screens** — migrate to use AppAssets, AppColors, AppTextStyles, spacing helpers, and validator localization keys
2. **Error handling in features** — ensure all RemoteDs use `ErrorHandler.handle()` and all cubits properly catch `AppException`
3. **Onboarding** — migrate to use AppAssets instead of raw strings
4. **Test error scenarios** — verify error messages localize correctly in both English and Arabic


---

# Phase 3 — Shared Widgets Library (COMPLETED)

## Summary of Changes

All changes in Phase 3 were scoped to `lib/core/widgets/` — no feature code was modified.

### 1. **Audited & Fixed Existing Widgets**

| Widget | Fixes |
|--------|-------|
| `CustomTextForm` (renamed from `custom_text_form_.dart`) | Added responsive padding import; fixed `contentPadding` to use `rw/rh` |
| `CustomTextButton` | Fixed button heights to use `rh()`: `40 → rh(40)`, `52 → rh(52)`, `56 → rh(56)` |
| `CustomAppBar` | Fixed all sizing to use responsive units: `padding`, `height`, `left`/`right` padding |
| `ErrorScreen` | ✅ Perfect (already uses `rw/rh/rf`, customColors, `.tr()`) |
| `OverlayLoader` | ✅ Perfect (already uses customColors, spacing helpers) |
| `AppDialogs` | ✅ Perfect (already uses localization keys) |
| `CustomAppDialog` | ✅ Perfect (already uses responsive sizing, customColors) |

### 2. **Created Missing Shared Widgets** (8 new widgets)

#### `LoadingShimmer` — Animated loading skeleton
- **Patterns:** `card(width, height)`, `circular(size)`, `line(width, height)`
- **Features:** Theme-aware colors, smooth animation, reusable across features
- **Replaces:** 8+ inline `CircularProgressIndicator` calls in features

#### `EmptyState` — Full-screen empty state
- **Variants:** Icon + title + description + optional CTA button
- **Features:** Theme-aware, responsive, centered layout
- **Replaces:** 5 separate `_buildEmpty` implementations in features

#### `SectionTitle` — Section header with optional trailing action
- **Variants:** Title only, or title + "See All" / "View all" trailing label
- **Features:** Responsive padding, theme-aware colors
- **Replaces:** Hardcoded section titles across features

#### `AppSearchField` — Search bar with clear button
- **Features:** Search icon, clear button (auto-hide), theme-aware border, responsive sizing
- **Replaces:** 3 incompatible search field implementations (flights, explore_places ×2)
- **Bonus:** Single controller, proper focus management

#### `FilterChipRow<T>` — Horizontal filter chips
- **Features:** Single/multi-select, generic item type, horizontal scroll, responsive spacing
- **Replaces:** Duplicate chip row implementations
- **Bonus:** Type-safe, reusable label mapper, customizable

#### `RatingStars` — 0–5 star display/input
- **Features:** Display mode (read-only), interactive mode (tap or drag to rate), half-star support
- **Replaces:** Hardcoded star display logic in multiple features
- **Bonus:** Customizable size, color, interactive feedback

#### `NetworkImageWithFallback` — Image with loading & error states
- **Features:** Shimmer loading, error placeholder with icon, theme-aware fallback color
- **Replaces:** Inline `Image.network` with error handling boilerplate
- **Bonus:** Configurable border radius, fallback icon, fit mode

#### `AppBackButton` — Standard back button
- **Features:** Theme-aware color (defaults to textPrimary), auto-pops, customizable
- **Replaces:** Inline back button implementations
- **Bonus:** Consistent padding, icon size, behavior across app

### 3. **Renamed for Clarity**
- **`custom_text_form_.dart` → `custom_text_form.dart`** — removed trailing underscore typo

### 4. **Created Widget Documentation**
- **`lib/core/widgets/README.md`** — comprehensive guide with:
  - One-line description of each widget
  - Usage examples for common scenarios
  - Convention checklist (colors, sizing, localization)
  - Instructions for adding new widgets

## Compilation Status
- **flutter analyze lib/core/widgets/:** ✅ 1 lint suggestion (SizedBox vs Container; not critical)
- **flutter analyze (full project):** ✅ 0 errors

## Impact Summary

**Before Phase 3:**
- 3 incompatible search field implementations (flights, explore_places ×2)
- 5+ separate empty-state widgets (inline or duplicated)
- 8+ inline `CircularProgressIndicator` loading patterns
- Hardcoded section titles, back buttons, images
- No shared rating, filter chip, or empty-state widgets

**After Phase 3:**
- ✅ Single `AppSearchField` (themed, clear button, responsive)
- ✅ Single `EmptyState` (icon + CTA, reusable)
- ✅ Single `LoadingShimmer` (animated, theme-aware)
- ✅ Shared `AppBackButton`, `SectionTitle`, `RatingStars`, `FilterChipRow`, `NetworkImageWithFallback`
- ✅ All widgets follow CLAUDE.md conventions (customColors, AppTextStyles, rw/rh/rr/rf, .tr())

## Widget Checklist

Every widget in `lib/core/widgets/`:
- ✅ Uses `context.customColors.*` (not raw `Color()`)
- ✅ Uses `AppColors.*` only for brand constants
- ✅ Uses `AppTextStyles.*` (not inline `TextStyle`)
- ✅ Uses `rw()`, `rh()`, `rr()`, `rf()` (not raw pixels)
- ✅ Supports light/dark mode automatically
- ✅ No hardcoded user-visible strings (uses `.tr()` where applicable)

## Next Steps

Phase 4 should focus on:
1. **Auth screens** — replace raw widgets with `CustomTextForm`, `CustomTextButton`, `AppBackButton`
2. **Home feature** — use `SectionTitle`, `LoadingShimmer`, `EmptyState`
3. **Explore Places** — use `AppSearchField`, `FilterChipRow`, `NetworkImageWithFallback`, `RatingStars`
4. **Flights** — use `AppSearchField`, `NetworkImageWithFallback`
5. **All features** — remove duplicate search fields, loading spinners, empty states

