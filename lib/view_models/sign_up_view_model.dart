import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/firebase/user_repository.dart';
import '../models/user_model.dart';

class SignUpViewModel extends ChangeNotifier {
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  SignUpViewModel(this.ref);

  UserModel? _user;
  UserModel? get user => _user;

  String? emailError;
  String? passwordError;

  // 입력값 검증 추가
  bool validateEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  Future<void> signUp(String email, String password) async {
    if (!validateEmail(email)) {
      emailError = '유효한 이메일 주소를 입력하세요.';
    } else if (!validatePassword(password)) {
      passwordError = '비밀번호는 6자 이상이어야 합니다.';
    } else {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _user = UserModel(
          uid: credential.user!.uid,
          email: email,
        );
        await _userRepository.setUser(_user!);
        emailError = null;
        passwordError = null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          passwordError = '비밀번호가 너무 약합니다.';
        } else if (e.code == 'email-already-in-use') {
          emailError = '이미 사용 중인 이메일입니다.';
        } else {
          emailError = '회원가입에 실패했습니다. (${e.code})'; // 상세 에러 코드 표시
          passwordError = '회원가입에 실패했습니다. (${e.code})';
        }
      }
    }

    notifyListeners();
  }
}
