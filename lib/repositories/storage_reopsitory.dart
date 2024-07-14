//repositories/storage_repository.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image file to Firebase Storage
  Future<String> uploadImage(File imageFile, String fileName) async {
    final Reference ref = _storage.ref().child('images/$fileName');
    final UploadTask uploadTask = ref.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  // Get the download URL of an image file
  Future<String> getDownloadURL(String fileName) async {
    final Reference ref = _storage.ref().child('images/$fileName');
    return await ref.getDownloadURL();
  }
}

final storageRepositoryProvider = Provider((ref) => StorageRepository());
