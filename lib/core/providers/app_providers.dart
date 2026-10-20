import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => MockAuthRepository());

final authSessionProvider = NotifierProvider<AuthController, AuthSession>(AuthController.new);

class AuthController extends Notifier<AuthSession> {
  @override
  AuthSession build() => const AuthSession(userId: null, isAuthenticated: false);

  Future<void> signInWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final session = await ref
        .read(authRepositoryProvider)
        .signInWithEmail(email: email, password: password);
    state = AuthSession(
      userId: session.userId,
      isAuthenticated: true,
      displayName: displayName ?? session.displayName,
    );
  }

  Future<void> signInWithGoogleMock() => signInWithEmail(
        email: 'maria.santos@exemplo.local',
        password: 'mock-google',
        displayName: 'Maria Santos',
      );

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthSession(userId: null, isAuthenticated: false);
  }
}
