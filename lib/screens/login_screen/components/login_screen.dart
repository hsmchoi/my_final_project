import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../view_models/login_view_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
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
                await viewModel.login(
                  emailController.text,
                  passwordController.text,
                );
                if (viewModel.emailError == null &&
                    viewModel.passwordError == null) {
                  context.go('/'); // 로그인 성공 시 홈 화면으로 이동
                }
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
