import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/profile/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/explore', builder: (_, __) => const ExploreScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
  ],
);
