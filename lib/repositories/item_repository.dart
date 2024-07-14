//repositories/item_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addItem(String userId, ItemModel item) async {
    try {
      final CollectionReference<Map<String, dynamic>> userItemsCollection =
          _firestore.collection('users').doc(userId).collection('items');

      final DocumentReference docRef =
          await userItemsCollection.add(item.toFirestore());

      await docRef.update({'id': docRef.id});
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  // Get items stream for a user
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
