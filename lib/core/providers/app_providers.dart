import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final authSessionProvider = FutureProvider<AuthSession>((ref) async {
  return const AuthSession(userId: null, isAuthenticated: false);
});
