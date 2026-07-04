// Time formatting helpers shared across flight-related UI.
//
// formatHm(dt)             → "14:30"
// formatHmOrDash(dt)       → "14:30" or "—"
// formatHmDate(dt)         → "14:30 · 29/06"
// formatHmFromIso(isoStr)  → "14:30" or ""

/// `HH:mm` from a non-null `DateTime`.
String formatHm(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

/// `HH:mm` from a nullable `DateTime`; returns `'—'` when null.
String formatHmOrDash(DateTime? dt) => dt == null ? '—' : formatHm(dt);

/// `HH:mm · DD/MM` from a nullable `DateTime`; returns `'—'` when null.
String formatHmDate(DateTime? dt) {
  if (dt == null) return '—';
  final hm = formatHm(dt);
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  return '$hm · $day/$month';
}

/// Parses an ISO-8601 string and returns `HH:mm`; returns `''` for null or
/// unparseable input (home-model fields store times as strings).
String formatHmFromIso(String? iso) {
  if (iso == null) return '';
  try {
    return formatHm(DateTime.parse(iso).toLocal());
  } catch (_) {
    return '';
  }
}
