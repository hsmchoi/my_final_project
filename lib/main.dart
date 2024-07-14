// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_final_project/firebase_options.dart';
import 'package:my_final_project/router.dart'; // router.dart import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access GoRouter through the function
    final GoRouter router = createRouter(ref);

    return MaterialApp.router(
      routerConfig: router, // Use the router here
      title: 'Heraclitus\' Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
