//views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for restarting the app
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_final_project/view_models/login_view_model.dart';
import 'package:my_final_project/widgets/custom_background.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final bool _showRestartButton = false;

  // Function to restart the app
  void restartApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.watch(loginViewModelProvider);

    // Use .when to listen for changes from authStateChangesProvider
    return ref.watch(authStateChangesProvider).when(
      data: (user) {
        if (user != null && !_showRestartButton) {
          // Check for login and avoid multiple restarts
          // Show restart message and button
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Login successful! To complete the process, please restart the app."),
              ElevatedButton(
                onPressed: () {
                  restartApp();
                },
                child: const Text("Restart"),
              ),
            ],
          );
        } else {
          // User is not logged in, show the login screen
          return Scaffold(
            body: Stack(
              children: [
                const CustomBackground(),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Email Login Button
                      _buildLoginButton(
                        icon: Icons.email,
                        onTap: () {
                          context.go('/login/email');
                        },
                      ),
                      // Google Login Button
                      _buildLoginButton(
                        icon: Icons.g_mobiledata,
                        onTap: () async {
                          await loginViewModel.signInWithGoogle();
                        },
                      ),
                      // Apple Login Button
                      _buildLoginButton(
                        icon: Icons.apple,
                        onTap: () async {
                          await loginViewModel.signInWithApple();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
      error: (error, stackTrace) {
        // Handle error state (e.g., display an error message)
        return Center(child: Text("Error: $error"));
      },
      loading: () {
        // Show a loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Login Button Widget
  Widget _buildLoginButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 30,
          color: const Color.fromARGB(255, 237, 190, 152),
        ),
      ),
    );
  }
}
