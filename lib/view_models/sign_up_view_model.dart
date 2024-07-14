//view_models/sign_up_view_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/user_model.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/repositories/user_repository.dart';

final signUpViewModelProvider = ChangeNotifierProvider((ref) {
  return SignUpViewModel(ref);
});

class SignUpViewModel extends ChangeNotifier {
  final Ref ref;

  SignUpViewModel(this.ref);

  String? emailError;
  String? passwordError;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    if (!validateEmail(email)) {
      emailError = 'Please enter a valid email address.';
      notifyListeners();
      return;
    } else if (!validatePassword(password)) {
      passwordError = 'Password must be at least 6 characters long.';
      notifyListeners();
      return;
    }

    try {
      await ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email, password);
      final User? currentUser = ref.read(authRepositoryProvider).user;

      if (currentUser != null) {
        final UserModel userModel = UserModel(
          uid: currentUser.uid,
          email: email,
        );
        await ref.read(userRepositoryProvider).setUser(userModel);
      }

      emailError = null;
      passwordError = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        passwordError = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        emailError = 'The account already exists for that email.';
      } else {
        emailError = 'Sign up failed.';
        passwordError = 'Sign up failed.';
      }
    }
    notifyListeners();
  }

  // Input validation
  bool validateEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }
}
