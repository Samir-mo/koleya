# DRY Audit — Phase 6

Scanned: `lib/features/flights/`, `lib/features/tracked_flight/`, `lib/features/home/widgets/`, `lib/features/explore_places/`

---

## Category A — Status pills / badges

### Candidate A1 — FlightStatusBadge (dot + colored label pill)

**Occurrence count:** 5

| File | Class | Lines | Notes |
|---|---|---|---|
| `features/flights/ui/widgets/flight_card.dart` | `_StatusBadge` | 207–239 | `font12Bold`, no border, bg alpha 0.12 |
| `features/home/ui/widgets/tracked_flight_card.dart` | `_StatusPill` | 323–386 | `font12Medium`, border alpha 0.4, bg alpha 0.18 |
| `features/home/ui/widgets/flight_update_card.dart` | inline | 128–153 | `font12Medium`, no border, bg alpha 0.12 |
| `features/tracked_flight/ui/tracked_flights_list_screen.dart` | `_StatusBadge` | 317–350 | `font12Medium`, border alpha 0.4, bg alpha 0.18; dot 5px |
| `features/home/ui/widgets/compact_tracked_card.dart` | inline | ~60–85 | own `_statusColor`, inline pill |

**What varies:**
- Font weight: `Bold` (flight_card) vs `Medium` (all others)
- Border: present on `_StatusPill` and list `_StatusBadge`; absent in the other 3
- Dot diameter: 6px most, 5px in list screen

**What's identical:** Container with circle dot + `Text(status)` in a `Row`, colored by status, rounded pill.

**Proposed API:**
```dart
FlightStatusBadge({
  required String status,   // raw status string — color/label derived internally
  bool showBorder = true,
})
```

**Risk:** Low

---

## Category B — Info chips (icon + text label)

### Candidate B1 — FlightInfoChip

**Occurrence count:** 3

| File | Class | Lines |
|---|---|---|
| `features/flights/ui/widgets/flight_card.dart` | `_InfoChip` | 410–439 |
| `features/tracked_flight/ui/tracked_flights_list_screen.dart` | `_InfoChip` | 378–406 |
| `features/home/ui/widgets/compact_tracked_card.dart` | `_Chip` (icon+label, no value col) | ~245–273 |

**What varies:** Background color (`surfaceVariant` vs `primary200 * 0.06`), text color (`secondary` vs `primary`), border present/absent.

**What's identical:** `Icon` + `Text` in `Row`, small rounded container, same 12px icon, same padding pattern.

**Proposed API:**
```dart
FlightInfoChip({
  required IconData icon,
  required String label,
})
```

**Risk:** Low

---

## Category C — Airline logo avatars

### Candidate C1 — AirlineAvatar

**Occurrence count:** 4

| File | Class | Shape | Size |
|---|---|---|---|
| `features/flights/ui/widgets/flight_card.dart` | `_AirlineLogo` | Rounded rect 10r | 44×44, fallback: flight icon |
| `features/home/ui/widgets/tracked_flight_card.dart` | `_AirlineLogo` | Circle | 42×42, fallback: initial letter |
| `features/tracked_flight/ui/tracked_flights_list_screen.dart` | `_AirlineLogo` | Circle | 38×38, fallback: initial letter |
| `features/home/ui/widgets/compact_tracked_card.dart` | `_AirlineLogo` | Circle | ~40×40, fallback: initial letter |

**What varies:** Shape (circle vs rounded rect), size, fallback style, image loader (`CachedNetworkImage` vs `Image.network`), bg color (white vs white×0.15 for dark headers).

**Proposed API:**
```dart
AirlineAvatar({
  required String logoUrl,
  String? name,          // for initial fallback
  double size = 42,
  bool circle = true,
  bool onDark = false,   // translucent white bg for dark header context
})
```

**Risk:** Medium — `onDark` flag needed for 2 of 4 call sites

---

## Category D — Route row (FROM → TO)

**Occurrence count:** 5

Files: `flight_card.dart`, `flight_details_screen.dart`, `tracked_flight_screen.dart`, `tracked_flights_list_screen.dart`, `home/tracked_flight_card.dart`.

**Risk:** High — light vs dark theme, center element (dashed line / plane icon / plain line), whether city names and times are shown all differ per context.

**Recommendation:** Skip. Too many behavioral differences; a unified widget would need 6+ params and would obscure intent.

---

## Category E — Detail info tile / label-value chip

**Occurrence count:** 2–3 (borderline)

- `_QuickInfo` in `flight_details_screen.dart` and `_QuickChip` in `tracked_flight_screen.dart` — only 2 occurrences; skip.
- `_Chip` (label above, value below) in `tracked_flight_card.dart` — unique; skip.

---

## Category F — Helper functions (high-value extractions)

### Candidate F1 — `flightStatusColor(String status)` → `Color`

**Occurrence count:** 6 independent copies

| File | Function |
|---|---|
| `features/flights/ui/widgets/flight_card.dart` | `FlightCard._statusColor` |
| `features/home/ui/widgets/flight_update_card.dart` | `_statusColor` |
| `features/home/ui/widgets/tracked_flight_card.dart` | `_StatusPill._color` |
| `features/tracked_flight/ui/tracked_flights_list_screen.dart` | `_TrackedCard._statusColor` |
| `features/home/ui/widgets/compact_tracked_card.dart` | `_statusColor` |
| `features/tracked_flight/ui/tracked_flight_screen.dart` | `_StatusCard._statusColor` (uses `customColors` tokens) |

**Critical divergence:** Different files map the same status to different colors:
- `BOARDING`: `green200` (flight_card, flight_update, tracked_flight_card, list_screen) vs `info` (tracked_flight_screen)
- `GATE_CHANGED`: `blue200` (home files) — absent from `flight_card` and `tracked_flight_screen`
- `LANDED`: `success` (flight_card, tracked_flight_screen) — absent from home files
- The `tracked_flight_screen` version uses `customColors.success/warning/error/info` (semantic), all others use raw `AppColors.*`

**Canonical mapping to extract** (use `AppColors` constants; `customColors` variant is only in the dark-theme screen and is an intentional design difference — flag in summary):
```dart
Color flightStatusColor(String status) { ... }
```

**Risk:** Low — pure function. High correctness value.

---

### Candidate F2 — `flightStatusLabel(String status)` → `String`

**Occurrence count:** 3

| File | Notes |
|---|---|
| `features/home/ui/widgets/flight_update_card.dart` | Uses `'home.status_*'.tr()` keys |
| `features/home/ui/widgets/tracked_flight_card.dart` | Uses same `'home.status_*'.tr()` keys |
| `features/flights/ui/widgets/flight_card.dart` | `s.replaceAll('_', ' ')` — no localization |

**Recommended canonical:** use `'home.status_*'.tr()` keys (already in en/ar). `flight_card` drops localization — migrate to use the helper.

**Risk:** Low

---

### Candidate F3 — `formatTime(DateTime)` → `HH:mm`

**Occurrence count:** 8+

All identical: `'${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}'`

Also a `formatTimeFull(DateTime)` variant (`HH:mm · DD/MM`) in 2 files — bundle together.

**Risk:** Low

---

### Candidate F4 — `flightStatusIcon(String status)` → `IconData`

**Occurrence count:** 2 (`flight_details_screen.dart`, `tracked_flight_screen.dart`)

Only 2 occurrences — skip as a standalone extraction, but bundle into the status helpers file alongside F1/F2 since it naturally belongs there.

---

## Recommendation Table

| # | Pattern | Occurrences | Risk | Recommend |
|---|---|---|---|---|
| 1 | `FlightStatusBadge` widget | 5 | low | **extract** |
| 2 | `formatTime` + `formatTimeFull` helpers | 8 | low | **extract** |
| 3 | `flightStatusColor` helper | 6 | low | **extract** — correctness risk |
| 4 | `flightStatusLabel` helper | 3 | low | **extract** (bundle with #3) |
| 5 | `flightStatusIcon` helper | 2 | low | **extract** (bundle with #3/#4, only 2 occurrences but belongs in same file) |
| 6 | `AirlineAvatar` widget | 4 | medium | **discuss** — needs `onDark` flag |
| 7 | `FlightInfoChip` (icon+label) | 3 | low | **extract** |
| 8 | `FlightRouteRow` | 5 | high | **skip** — too many behavioral differences |
| 9 | `DashedLine` | 2 | low | **skip** (only 2 occurrences, two different implementations) |

### Suggested extraction groupings

**Group A — helpers** (do first; widgets #1 and #7 will import these):
- `#2 → lib/core/utils/helpers/flight_time_helpers.dart`
  - `String formatHm(DateTime dt)` — `HH:mm`
  - `String formatHmDate(DateTime dt)` — `HH:mm · DD/MM`
- `#3 + #4 + #5 → lib/core/utils/helpers/flight_status_helpers.dart`
  - `Color flightStatusColor(String status)`
  - `String flightStatusLabel(String status)`
  - `IconData flightStatusIcon(String status)`

**Group B — widgets** (do after helpers):
- `#1 → lib/core/widgets/flight_status_badge.dart` (imports status helpers)
- `#7 → lib/core/widgets/flight_info_chip.dart`
- `#6 → lib/core/widgets/airline_avatar.dart` *(if approved)*

---

*Audit complete. Awaiting approval — reply with which numbers to execute.*
