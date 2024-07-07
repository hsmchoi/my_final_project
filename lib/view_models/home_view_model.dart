import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase/storage_repository.dart';
import '../models/item_model.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel extends ChangeNotifier {
  final Ref ref;
  final StorageRepository _storageRepository = StorageRepository();

  HomeViewModel(this.ref);

  List<ItemModel> _items = [];
  List<ItemModel> get items => _items;

  Future<void> fetchItems() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('items').get();
    _items =
        querySnapshot.docs.map((doc) => ItemModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    // 고유한 파일 이름 생성 (예: UUID 사용)
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _storageRepository.uploadImage(imageFile, fileName);
  }

  Future<String> getDownloadURL(String fileName) async {
    return await _storageRepository.getDownloadURL(fileName);
  }

  void addItem(ItemModel newItem) {
    _items.add(newItem);
    notifyListeners(); // 내부적으로 notifyListeners 호출
  }
}
