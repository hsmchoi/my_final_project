// sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../view_models/sign_up_view_model.dart';

final signUpViewModelProvider = ChangeNotifierProvider((ref) {
  return SignUpViewModel(ref);
});

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signUpViewModelProvider);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                errorText: viewModel.emailError,
              ),
              onChanged: (value) {
                viewModel.emailError = null; // 에러 메시지 초기화
              },
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                errorText: viewModel.passwordError,
              ),
              obscureText: true,
              onChanged: (value) {
                viewModel.passwordError = null; // 에러 메시지 초기화
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (viewModel.validateEmail(emailController.text) &&
                    viewModel.validatePassword(passwordController.text)) {
                  await viewModel.signUp(
                      emailController.text, passwordController.text);
                  if (viewModel.user != null) {
                    context.go('/');
                  }
                }
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
