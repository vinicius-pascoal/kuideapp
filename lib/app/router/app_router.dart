import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/presentation/widget_catalog_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/logout_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/quick_access_screen.dart';
import '../../features/health/presentation/health_history_screen.dart';
import '../../features/medications/presentation/add_medication_screen.dart';
import '../../features/medications/presentation/medications_screen.dart';
import '../../features/routine/presentation/routine_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/appointments/presentation/add_appointment_screen.dart';
import '../../features/shopping/presentation/shopping_list_screen.dart';
import '../../features/profile/presentation/profile_placeholder_screen.dart';
import '../../shared/widgets/kuide_scaffold.dart';
import '../../shared/widgets/module_placeholder_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/logout', builder: (context, state) => const LogoutScreen()),
    GoRoute(
      path: '/onboarding/medicines',
      builder: (context, state) => const OnboardingScreen(step: OnboardingStep.medicines),
    ),
    GoRoute(
      path: '/onboarding/doctor',
      builder: (context, state) => const OnboardingScreen(step: OnboardingStep.doctor),
    ),
    GoRoute(
      path: '/onboarding/emergency',
      builder: (context, state) => const OnboardingScreen(step: OnboardingStep.emergency),
    ),
    GoRoute(path: '/quick-access', builder: (context, state) => const QuickAccessScreen()),
    GoRoute(path: '/medications', builder: (context, state) => const MedicationsScreen()),
    GoRoute(path: '/medications/add', builder: (context, state) => const AddMedicationScreen()),
    GoRoute(path: '/appointments', builder: (context, state) => const AppointmentsScreen()),
    GoRoute(path: '/appointments/add', builder: (context, state) => const AddAppointmentScreen()),
    GoRoute(path: '/shopping', builder: (context, state) => const ShoppingListScreen()),
    GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
    GoRoute(path: '/contacts', builder: (context, state) => const ModulePlaceholderScreen(title: 'Pessoas importantes')),
    GoRoute(path: '/emergency', builder: (context, state) => const ModulePlaceholderScreen(title: 'Central de emergência')),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          KuideScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/health',
              builder: (context, state) => const HealthHistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/routine',
              builder: (context, state) => const RoutineScreen(),
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
