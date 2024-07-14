//models/item_model
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id; // Firestore 문서 ID
  final String questionId; // 질문 ID
  final String content; // 답변 내용
  final Timestamp createdAt; // 작성 시간

  ItemModel({
    required this.id,
    required this.questionId,
    required this.content,
    required this.createdAt,
  });

  // Firestore 문서에서 ItemModel 객체 생성
  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ItemModel(
      id: doc.id,
      questionId: data['questionId'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  // Firestore에 저장할 데이터 형태로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'questionId': questionId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
