//router.dart
import 'package:go_router/go_router.dart';
import 'package:my_final_project/screens/login_screen/components/login_screen_email.dart';
import 'screens/home_screen/components/home_screen.dart';
import 'screens/login_screen/components/login_screen_choice.dart';

final router = GoRouter(
  initialLocation: HomeScreen.routeURL,
  routes: [
    GoRoute(
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
