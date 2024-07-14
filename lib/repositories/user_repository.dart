//repositories/user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  // Get a user by their UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection(_collectionName).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Create or update a user
  Future<void> setUser(UserModel user) async {
    await _firestore.collection(_collectionName).doc(user.uid).set(user.toFirestore());
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository());