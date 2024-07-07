import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen/components/home_screen.dart';
import 'screens/login_screen/components/login_screen.dart';
import 'view_models/user_view_model.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final userViewModel = ref.watch(userViewModelProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => userViewModel.user != null
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = userViewModel.user != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null; // no redirect
    },
  );
});
