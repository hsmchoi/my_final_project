import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await users.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>); // 타입 캐스팅 추가
      } else {
        return null; // 사용자를 찾을 수 없는 경우 null 반환
      }
    } catch (e) {
      // 에러 처리 로직 추가 (예: 로그 출력, 사용자에게 알림 등)
      print('Error fetching user data: $e');
      return null;
    }
    
  }

  Future<void> setUser(UserModel user) async {
    await users.doc(user.uid).set(user.toFirestore());
  }
  
}
