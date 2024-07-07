import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile, String fileName) async {
    final ref = storage.ref().child('images/$fileName');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> getDownloadURL(String fileName) async {
    final ref = storage.ref().child('images/$fileName');
    return await ref.getDownloadURL();
  }
}
