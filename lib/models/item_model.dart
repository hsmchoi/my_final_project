import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String id; // Firestore 문서 ID
  final String title; // 아이템 제목
  final String imageName; // 이미지 파일 이름 (Firebase Storage 경로)

  ItemModel({
    required this.id,
    required this.title,
    required this.imageName,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ItemModel(
      id: doc.id,
      title: data['title'],
      imageName: data['imageName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'imageName': imageName,
    };
  }
}
