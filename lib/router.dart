// lib/router.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/views/email_login_screen.dart';
import 'package:my_final_project/views/home_screen.dart';
import 'package:my_final_project/views/login_screen.dart';
import 'package:my_final_project/views/sign_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Function to create GoRouter with access to WidgetRef
GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: 'email',
            builder: (BuildContext context, GoRouterState state) =>
                const EmailLoginScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Now you can use ref.read here
      final bool isLoggedIn =
          ref.read(authRepositoryProvider).isLoggedIn;
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