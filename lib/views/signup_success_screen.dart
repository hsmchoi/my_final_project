//views/signup_success_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({Key? key}) : super(key: key);

  void restartApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 32),
            const Text(
              "회원가입이 완료되었습니다!\n앱을 다시 시작해주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: restartApp,
              child: const Text("앱 다시 시작"),
            ),
          ],
        ),
      ),
    );
  }
}