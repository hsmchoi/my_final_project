//models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  String? displayName; // 닉네임은 선택적으로 입력 가능

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  // Firestore 문서에서 UserModel 객체 생성
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
    );
  }

  // Firestore에 저장할 데이터 형태로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
    };
  }
}
