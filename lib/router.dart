// In router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/views/email_login_screen.dart';
import 'package:my_final_project/views/home_screen.dart';
import 'package:my_final_project/views/login_screen.dart';
import 'package:my_final_project/views/post_screen.dart'; // Don't forget to import PostsScreen
import 'package:my_final_project/views/sign_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Function to create GoRouter with access to WidgetRef

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: <GoRoute>[
      // ... (기존 라우트) ...

      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0), // 오른쪽에서 왼쪽으로
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: 'posts',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PostScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // 왼쪽에서 오른쪽으로
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Now you can use ref.read here
      final bool isLoggedIn = ref.read(authRepositoryProvider).isLoggedIn;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      } else if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}
