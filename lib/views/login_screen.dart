//views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/view_models/login_view_model.dart';
import 'package:my_final_project/widgets/custom_background.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.watch(loginViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Custom Background
          const CustomBackground(),

          // Login Buttons
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
                    Navigator.pushNamed(context, '/login/email');
                  },
                ),
                // Google Login Button
                _buildLoginButton(
                  icon: Icons.g_mobiledata,
                  onTap: () async {
                    await loginViewModel
                        .signInWithGoogle(); // Call the signInWithGoogle method
                  },
                ),
                // Apple Login Button
                _buildLoginButton(
                  icon: Icons.apple,
                  onTap: () async {
                    await loginViewModel
                        .signInWithApple(); // Call the signInWithApple method
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
