class AuthSession {
  const AuthSession({
    required this.userId,
    required this.isAuthenticated,
    this.displayName,
  });

  final String? userId;
  final bool isAuthenticated;
  final String? displayName;
}

class MockAuthRepository implements AuthRepository {
  AuthSession _session = const AuthSession(userId: null, isAuthenticated: false);

  @override
  Future<AuthSession> currentSession() async => _session;

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _session = AuthSession(
      userId: email.toLowerCase(),
      isAuthenticated: true,
      displayName: email.split('@').first,
    );
    return _session;
  }

  @override
  Future<void> signOut() async {
    _session = const AuthSession(userId: null, isAuthenticated: false);
  }
}

abstract interface class AuthRepository {
  Future<AuthSession> currentSession();
  Future<AuthSession> signInWithEmail({required String email, required String password});
  Future<void> signOut();
}
