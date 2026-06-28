# Core Widgets Library

Reusable, theme-aware UI components following CLAUDE.md conventions. All widgets use `customColors`, `AppColors`, `AppTextStyles`, and responsive sizing (`rw/rh/rr/rf`).

## Layout & Structure

### AppBackButton
Standard back button with consistent styling. Auto-pops on tap.
```dart
AppBackButton() // Pops context
AppBackButton(color: Colors.white, onPressed: () {})
```

### CustomAppBar
Header bar with title and optional leading widget (e.g., back button).
```dart
CustomAppBar(
  title: 'Screen Title',
  leading: Icon(Icons.menu),
  onLeadingPressed: () {},
)
```

### SectionTitle
Title with optional trailing "See All" or similar action.
```dart
SectionTitle(title: 'Recent Flights')
SectionTitle(
  title: 'Featured',
  trailingLabel: 'View all',
  onTrailingPressed: () {},
)
```

## Input & Forms

### CustomTextForm
Outlined text field with password toggle and validation support.
```dart
CustomTextForm(
  hintText: 'Email',
  validator: (value) => Validators.email(value),
)
CustomTextForm(
  hintText: 'Password',
  isPassword: true,
)
```

### CustomTextButton
Elevated, outlined, or text-only button with loading and disabled states.
```dart
CustomTextButton(text: 'Submit', onPressed: () {})
CustomTextButton.outlined(text: 'Cancel', onPressed: () {})
CustomTextButton.text(text: 'Skip', onPressed: () {})
CustomTextButton(
  text: 'Loading...',
  isLoading: true,
  onPressed: () {},
)
```

### AppSearchField
Search input with prefix icon and clear button. Theme-aware.
```dart
AppSearchField(
  hintText: 'Search...',
  onChanged: (value) {},
)
AppSearchField(
  hintText: 'Search flights',
  controller: _controller,
  onClear: () => _controller.clear(),
)
```

## Filters & Selection

### FilterChipRow
Horizontal scrollable filter chips; single or multi-select.
```dart
FilterChipRow<String>(
  items: ['All', 'Restaurants', 'Shops'],
  selected: _selected,
  onSelected: (value) => setState(() => _selected = value),
)
```

### RatingStars
Display or edit 0–5 star rating. Supports half stars and interactive mode.
```dart
RatingStars(rating: 4.5)
RatingStars(
  rating: _rating,
  interactive: true,
  onRatingChanged: (newRating) => setState(() => _rating = newRating),
)
```

## Images & Loading

### NetworkImageWithFallback
Loads image from URL with shimmer loading and error fallback.
```dart
NetworkImageWithFallback(
  imageUrl: 'https://...',
  width: 100,
  height: 100,
)
NetworkImageWithFallback(
  imageUrl: imageUrl,
  width: double.infinity,
  height: 200,
  borderRadius: 12,
  fallbackIcon: Icons.no_photography_outlined,
)
```

### LoadingShimmer
Animated shimmer effect for skeleton loading. Multiple styles.
```dart
LoadingShimmer.card(width: 100.w, height: 60.h)
LoadingShimmer.circular(size: 48.w)
LoadingShimmer.line(width: double.infinity, height: 12.h)
```

## State & Messages

### EmptyState
Full-screen empty state with icon, title, description, and optional CTA.
```dart
EmptyState(
  icon: Icons.inbox_outlined,
  title: 'No items',
  description: 'Start adding to get started',
)
EmptyState(
  icon: Icons.search_off,
  title: 'No results',
  description: 'Try a different search',
  actionLabel: 'Clear',
  onAction: () {},
)
```

### ErrorScreen
Full-screen error with icon, title, description, and retry button.
```dart
ErrorScreen(
  error: exception.message,
  onRetry: () {},
)
```

### CustomAppDialog
Modal dialog with title, message, icon, and up to 2 action buttons.
```dart
CustomAppDialog(
  title: 'Confirm',
  message: 'Are you sure?',
  primaryButtonText: 'Yes',
  onPrimaryPressed: () {},
  secondaryButtonText: 'No',
  icon: Icons.help_outline_rounded,
)
```

## Dialog Helpers

### AppDialogs
Static helpers for common dialog patterns.
```dart
AppDialogs.showInfo(context, message: 'Done!')
AppDialogs.showSuccess(context, message: 'Saved')
AppDialogs.showError(context, message: 'Error occurred')
AppDialogs.showWarning(context, message: 'Be careful')
AppDialogs.showConfirm(
  context,
  message: 'Continue?',
  onConfirm: () {},
)
```

### OverlayLoader
Semi-transparent loading overlay that blocks interactions.
```dart
OverlayLoader(
  isLoading: _isLoading,
  message: 'Loading...',
  child: YourContent(),
)
```

---

## Conventions

All widgets follow these rules:
- ✅ Use `context.customColors.*` for theme-aware colors
- ✅ Use `AppColors.*` only for brand constants
- ✅ Use `AppTextStyles.*` for all text
- ✅ Use `rw()`, `rh()`, `rr()`, `rf()` for responsive sizing
- ✅ Use `.tr()` for all user-facing strings
- ✅ Support light/dark mode automatically
- ✅ No hardcoded hex colors, padding, or font sizes in widgets

## Adding New Widgets

1. Create widget in `lib/core/widgets/`
2. Follow naming: `lowercase_with_underscores.dart`
3. Use CLAUDE.md conventions for colors, sizing, localization
4. Add usage examples in comments
5. Update this README
6. Verify: `flutter analyze lib/core/widgets/`
