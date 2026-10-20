import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/presentation/widget_catalog_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/logout_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/home/presentation/home_placeholder_screen.dart';
import '../../features/health/presentation/health_placeholder_screen.dart';
import '../../features/profile/presentation/profile_placeholder_screen.dart';
import '../../features/routine/presentation/routine_placeholder_screen.dart';
import '../../shared/widgets/kuide_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/logout', builder: (context, state) => const LogoutScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          KuideScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePlaceholderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/health',
              builder: (context, state) => const HealthPlaceholderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/routine',
              builder: (context, state) => const RoutinePlaceholderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePlaceholderScreen(),
            ),
          ],
        ),
      ],
    ),
    if (kDebugMode)
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const WidgetCatalogScreen(),
      ),
  ],
);
