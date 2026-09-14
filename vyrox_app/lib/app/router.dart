import 'package:go_router/go_router.dart';

import '../core/models/creation.dart';
import '../features/auth/login_screen.dart';
import '../features/create/create_screen.dart';
import '../features/create/create_tool_screen.dart';
import '../features/creations/creation_detail_screen.dart';
import '../features/creations/creations_screen.dart';
import '../features/explore/explore_detail_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/vip/vip_screen.dart';
import '../shell/vyrox_shell.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return VyroxShell(navigationShell: navigationShell);
        },
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
                path: '/create',
                builder: (context, state) => const CreateScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/creations',
                builder: (context, state) => const CreationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/vip',
        builder: (context, state) => const VipScreen(),
      ),
      GoRoute(
        path: '/tool/:tool',
        builder: (context, state) {
          final tool = creationTypeFromParam(state.pathParameters['tool']!);
          final prompt = state.uri.queryParameters['prompt'] ?? '';
          return CreateToolScreen(tool: tool, initialPrompt: prompt);
        },
      ),
      GoRoute(
        path: '/explore/detail/:id',
        builder: (context, state) {
          return ExploreDetailScreen(id: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/creations/detail/:id',
        builder: (context, state) {
          return CreationDetailScreen(id: state.pathParameters['id']!);
        },
      ),
    ],
  );
}
