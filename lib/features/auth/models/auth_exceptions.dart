class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();
}

class AuthFailureException implements Exception {
  const AuthFailureException(this.message);

  final String message;
}
