class AuthSession {
  const AuthSession({required this.userId, required this.isAuthenticated});

  final String? userId;
  final bool isAuthenticated;
}

abstract interface class AuthRepository {
  Future<AuthSession> currentSession();
  Future<AuthSession> signInWithEmail({required String email, required String password});
  Future<void> signOut();
}
