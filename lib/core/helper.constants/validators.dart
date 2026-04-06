/// Shared validators for the app.
/// South Africa phone: 10 digits, must start with 0 (e.g. 0821234567).
class Validators {
  Validators._();

  /// South Africa phone pattern: exactly 10 digits, first digit must be 0.
  static final RegExp _saPhoneRegex = RegExp(r'^0\d{9}$');

  /// Maximum length for South Africa phone numbers.
  static const int southAfricaPhoneMaxLength = 10;

  /// Validates a required South Africa phone number.
  /// Returns an error message or null if valid.
  static String? validateSouthAfricaPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required';
    }
    final trimmed = value.trim();
    if (trimmed.length != southAfricaPhoneMaxLength) {
      return 'Phone must be 10 digits (e.g. 0821234567)';
    }
    if (!trimmed.startsWith('0')) {
      return 'Phone must start with 0';
    }
    if (!_saPhoneRegex.hasMatch(trimmed)) {
      return 'Enter a valid South African phone (10 digits, starting with 0)';
    }
    return null;
  }

  /// Validates an optional South Africa phone number.
  /// Empty is allowed; if not empty, must be valid SA format.
  static String? validateSouthAfricaPhoneOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return validateSouthAfricaPhone(value);
  }
}
