abstract final class UsernameValidator {
  static final RegExp _usernamePattern = RegExp(r'^[a-z0-9_]+$');

  static String normalize(String username) => username.trim().toLowerCase();

  static String? validate(String username) {
    final normalizedUsername = normalize(username);

    if (normalizedUsername.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    if (normalizedUsername.length > 18) {
      return 'Username must be 18 characters or less.';
    }

    if (!_usernamePattern.hasMatch(normalizedUsername)) {
      return 'Use only lowercase letters, numbers, and underscores.';
    }

    return null;
  }
}
