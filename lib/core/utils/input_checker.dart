/// Utility class for input validation and sanitization.
class InputChecker {
  InputChecker._();

  /// Checks if a string is null, empty, or contains only whitespace.
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Validates email format.
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates minimum length requirement.
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validates maximum length limit.
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }
}
