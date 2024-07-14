// models/item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String questionId;
  final String questionContent; // Add this new field!
  final String content;
  final Timestamp createdAt;

  ItemModel({
    required this.id,
    required this.questionId,
    required this.questionContent, // Initialize this field
    required this.content,
    required this.createdAt,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ItemModel(
      id: doc.id,
      questionId: data['questionId'],
      questionContent: data['questionContent'] ?? '', // Fetch from Firestore
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'questionId': questionId,
      'questionContent': questionContent, // Save to Firestore
      'content': content,
      'createdAt': createdAt,
    };
  }
}
