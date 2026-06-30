import 'package:easy_localization/easy_localization.dart';

/// Form Validators
/// Provides validation functions for common form fields
class Validators {
  Validators._();

  static String? required(final String? value, {final String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'validators.required'.tr(args: [fieldName ?? 'field']);
    }
    return null;
  }

  static String? email(final String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.email_required'.tr();
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'validators.email_invalid'.tr();
    }

    return null;
  }

  static String? password(final String? value, {final int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'validators.password_required'.tr();
    }

    if (value.length < minLength) {
      return 'validators.password_min_length'.tr(args: [minLength.toString()]);
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'validators.password_uppercase'.tr();
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'validators.password_lowercase'.tr();
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'validators.password_number'.tr();
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'validators.password_special_char'.tr();
    }

    return null;
  }

  static String? confirmPassword(final String? value, final String? password) {
    if (value == null || value.isEmpty) {
      return 'validators.password_confirm_required'.tr();
    }

    if (value != password) {
      return 'validators.password_mismatch'.tr();
    }

    return null;
  }

  static String? phone(final String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.phone_required'.tr();
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'validators.phone_invalid'.tr();
    }

    return null;
  }

  static String? minLength(
    final String? value,
    final int length, {
    final String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr(args: [fieldName ?? 'field']);
    }

    if (value.length < length) {
      return 'validators.min_length'.tr(
        args: [fieldName ?? 'field', length.toString()],
      );
    }

    return null;
  }

  static String? maxLength(
    final String? value,
    final int length, {
    final String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return 'validators.max_length'.tr(
        args: [fieldName ?? 'field', length.toString()],
      );
    }

    return null;
  }

  static String? numeric(final String? value, {final String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr(args: [fieldName ?? 'field']);
    }

    if (double.tryParse(value) == null) {
      return 'validators.numeric'.tr(args: [fieldName ?? 'field']);
    }

    return null;
  }

  static String? url(final String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.url_required'.tr();
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'validators.url_invalid'.tr();
    }

    return null;
  }

  static String? creditCard(final String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.credit_card_required'.tr();
    }

    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'validators.credit_card_invalid'.tr();
    }

    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'validators.credit_card_invalid'.tr();
    }

    return null;
  }

  static String? date(final String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.date_required'.tr();
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return 'validators.date_format'.tr();
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'validators.date_invalid'.tr();
    }

    if (month < 1 || month > 12) {
      return 'validators.date_month_invalid'.tr();
    }

    if (day < 1 || day > 31) {
      return 'validators.date_day_invalid'.tr();
    }

    return null;
  }

  static String? Function(String?) combine(
    final List<String? Function(String?)> validators,
  ) {
    return (final String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
