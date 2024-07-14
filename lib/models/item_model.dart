//models/item_model
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String questionId;
  final String content;
  final Timestamp createdAt;

  ItemModel({
    required this.id,
    required this.questionId,
    required this.content,
    required this.createdAt,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ItemModel(
      id: doc.id,
      questionId: data['questionId'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'questionId': questionId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
