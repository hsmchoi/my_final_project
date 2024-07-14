//view_models/login_view_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';

final loginViewModelProvider = ChangeNotifierProvider((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends ChangeNotifier {
  final Ref ref;

  LoginViewModel(this.ref);

  String? emailError;
  String? passwordError;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
      emailError = null;
      passwordError = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emailError = 'User not found.';
      } else if (e.code == 'wrong-password') {
        passwordError = 'Incorrect password.';
      } else {
        emailError = 'Login failed.';
        passwordError = 'Login failed.';
      }
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (e) {
      print('Error signing in with Google: $e');
      // 오류를 처리합니다. 예를 들어 사용자에게 오류 메시지를 표시합니다.
    }
  }

  Future<void> signInWithApple() async {
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
    } catch (e) {
      print('Error signing in with Apple: $e');
      // 오류를 처리합니다. 예를 들어 사용자에게 오류 메시지를 표시합니다.
    }
  }
}
