import '../constatnts/app_constants.dart';

abstract class Validators {
  /// Validates Jordan national number (10 digits, starts with 1 or 2 followed by specific digits)
  /// Format: 1XXXXXXXXX or 2XXXXXXXXX (10 digits total)
  static String? nationalNumber(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'National number is required';
    }
    final trimmed = value.trim();
    if (trimmed.length != AppConstants.nationalNumberLength) {
      return invalidMsg ??
          'National number must be ${AppConstants.nationalNumberLength} digits';
    }
    final digitsOnly = RegExp(r'^\d+$');
    if (!digitsOnly.hasMatch(trimmed)) {
      return invalidMsg ?? 'National number must contain digits only';
    }
    // Jordan national numbers start with 1 or 2
    if (!trimmed.startsWith('1') && !trimmed.startsWith('2')) {
      return invalidMsg ?? 'Invalid national number format';
    }
    return null;
  }

  /// Email validation
  static String? email(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return invalidMsg ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// Password validation
  static String? password(
    String? value, {
    String? requiredMsg,
    String? weakMsg,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Password is required';
    }
    if (value.length < 8) {
      return weakMsg ?? 'Password must be at least 8 characters';
    }
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    if (!hasUpper || !hasDigit) {
      return weakMsg ?? 'Password must include uppercase letters and numbers';
    }
    return null;
  }

  /// Confirm password
  static String? confirmPassword(
    String? value,
    String? original, {
    String? requiredMsg,
    String? mismatchMsg,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Please confirm your password';
    }
    if (value != original) {
      return mismatchMsg ?? 'Passwords do not match';
    }
    return null;
  }

  /// Full name validation
  static String? fullName(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Full name is required';
    }
    if (value.trim().length < 3) {
      return invalidMsg ?? 'Name must be at least 3 characters';
    }
    return null;
  }

  /// Phone number (Jordanian) — 07XXXXXXXX
  static String? phoneNumber(
    String? value, {
    String? requiredMsg,
    String? invalidMsg,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Phone number is required';
    }
    final phone = value.trim();
    final phoneRegex = RegExp(r'^07[0-9]{8}$');
    if (!phoneRegex.hasMatch(phone)) {
      return invalidMsg ??
          'Please enter a valid Jordanian phone number (07XXXXXXXX)';
    }
    return null;
  }
}
