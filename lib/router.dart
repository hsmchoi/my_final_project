
//router.dart 
import 'package:go_router/go_router.dart';

import 'screens/home_screen/components/home_screen.dart';

final router = GoRouter(
  initialLocation: HomeScreen.routeURL,
  routes: [
    GoRoute(
      path: HomeScreen.routeURL,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
