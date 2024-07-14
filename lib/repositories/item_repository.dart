//repositories/item_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new item (answer) for a user
  Future<void> addItem(String userId, ItemModel item) async {
    try {
      final CollectionReference<Map<String, dynamic>> userItemsCollection =
          _firestore.collection('users').doc(userId).collection('items');

      final DocumentReference docRef =
          await userItemsCollection.add(item.toFirestore());

      // Firestore에서 자동으로 생성된 ID를 item 객체에 업데이트
      await docRef.update({'id': docRef.id});
    } catch (e) {
      print('Error adding item: $e');
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  // Get all items (answers) for a user
  Stream<List<ItemModel>> getItemsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ItemModel.fromFirestore(doc)).toList());
  }
}

final itemRepositoryProvider = Provider((ref) => ItemRepository());
