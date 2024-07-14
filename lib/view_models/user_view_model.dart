//view_models/user_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

final userViewModelProvider = ChangeNotifierProvider((ref) {
  return UserViewModel(ref);
});

class UserViewModel extends ChangeNotifier {
  final Ref read;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  UserViewModel(this.read);

  UserModel? _user;
  UserModel? get user => _user;

  String? emailError;
  String? passwordError;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        _user = await _userRepository.getUser(currentUser.uid);
        notifyListeners();
      }
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
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
