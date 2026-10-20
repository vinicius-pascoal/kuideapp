import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/core/repositories/auth_repository.dart';

void main() {
  test('sessão mock pode ser criada e removida localmente', () async {
    final repository = MockAuthRepository();

    expect((await repository.currentSession()).isAuthenticated, isFalse);

    final signedIn = await repository.signInWithEmail(
      email: 'maria@exemplo.local',
      password: 'segredo',
    );
    expect(signedIn.isAuthenticated, isTrue);
    expect(signedIn.userId, 'maria@exemplo.local');

    await repository.signOut();
    expect((await repository.currentSession()).isAuthenticated, isFalse);
  });
}
