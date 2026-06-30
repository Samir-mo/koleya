import 'package:flutter/foundation.dart';
import '../models/boarding_pass_data.dart';

/// Parses IATA Bar Coded Boarding Pass (BCBP) format strings.
/// Pure — no side effects, no exceptions thrown to callers.
class BcbpParser {
  BcbpParser._();

  static BoardingPassData? parse(String raw) {
    try {
      final s = raw.trim();
      if (s.isEmpty) return null;
      if (!s.startsWith('M')) return null;
      if (s.length < 58) return null;

      // Fixed-width fields (1-based positions → 0-based substrings)
      final pnrRaw = s.substring(22, 29).trim(); // pos 23-29
      final fromCode = s.substring(29, 32).trim(); // pos 30-32
      final toCode = s.substring(32, 35).trim(); // pos 33-35
      final carrierRaw = s.substring(35, 38).trim(); // pos 36-38
      final flightNumRaw = s.substring(38, 43).trim(); // pos 39-43
      final julianRaw = s.substring(43, 46).trim(); // pos 44-46
      final seatRaw = s.substring(47, 51).trim(); // pos 48-51
      final nameRaw = s.substring(2, 22).trim(); // pos 3-22

      if (fromCode.isEmpty || toCode.isEmpty || carrierRaw.isEmpty) return null;

      // Passenger name: "LASTNAME/FIRSTNAME" → "Firstname Lastname"
      final passengerName = _parseName(nameRaw);

      // Flight number: airline code + numeric part stripped of leading zeros
      final numericPart = int.tryParse(flightNumRaw) ?? 0;
      final flightNumber =
          '$carrierRaw${numericPart > 0 ? numericPart : flightNumRaw}';

      // Julian day → DateTime
      DateTime? departureDate;
      final julianDay = int.tryParse(julianRaw);
      if (julianDay != null && julianDay >= 1 && julianDay <= 366) {
        departureDate = _julianToDate(julianDay);
      }

      if (kDebugMode) {
        debugPrint('[BcbpParser] Parsed: $flightNumber $fromCode→$toCode');
      }

      return BoardingPassData(
        passengerName: passengerName,
        flightNumber: flightNumber,
        airlineCode: carrierRaw,
        fromCode: fromCode,
        toCode: toCode,
        departureDate: departureDate,
        seat: seatRaw.isNotEmpty ? seatRaw : null,
        pnr: pnrRaw.isNotEmpty ? pnrRaw : null,
        rawData: raw,
      );
    } catch (_) {
      return null;
    }
  }

  static String _parseName(String raw) {
    try {
      final parts = raw.split('/');
      if (parts.length >= 2) {
        final first = parts[1].trim();
        final last = parts[0].trim();
        if (first.isNotEmpty && last.isNotEmpty) {
          return '${_capitalize(first)} ${_capitalize(last)}';
        }
      }
      return _capitalize(raw.replaceAll('/', ' ').trim());
    } catch (_) {
      return raw;
    }
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static DateTime _julianToDate(int day) {
    final now = DateTime.now();
    var candidate = DateTime(now.year, 1, 1).add(Duration(days: day - 1));
    // If the date is more than 30 days in the past, assume next year
    if (candidate.isBefore(now.subtract(const Duration(days: 30)))) {
      candidate = DateTime(now.year + 1, 1, 1).add(Duration(days: day - 1));
    }
    return candidate;
  }
}
