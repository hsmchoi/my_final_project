import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_view_model.dart';

final loginViewModelProvider = ChangeNotifierProvider((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends ChangeNotifier {
  final Ref ref;
  String? emailError;
  String? passwordError;

  LoginViewModel(this.ref);

  Future<void> login(String email, String password) async {
    try {
      await ref.read(userViewModelProvider).login(email, password);
      emailError = null;
      passwordError = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emailError = '사용자를 찾을 수 없습니다.';
      } else if (e.code == 'wrong-password') {
        passwordError = '비밀번호가 틀렸습니다.';
      } else {
        emailError = '로그인에 실패했습니다.';
        passwordError = '로그인에 실패했습니다.';
      }
    }
    notifyListeners();
  }
}
