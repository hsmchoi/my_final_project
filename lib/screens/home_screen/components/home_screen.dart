import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_final_project/view_models/home_view_model.dart';

import '../../../models/item_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: ListView.builder(
        itemCount: viewModel.items.length,
        itemBuilder: (context, index) {
          final item = viewModel.items[index];
          return ListTile(
            title: Text(item.title),
            leading: FutureBuilder<String>(
              future: viewModel.getDownloadURL(item.imageName), // null 체크 제거
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // 로딩 중 표시
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error); // 에러 발생 시 표시
                } else {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                }
              },
            ),
            // ... (각 항목에 대한 UI 표시)
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            final downloadURL =
                await viewModel.uploadImage(File(pickedFile.path));

            // 1. 새로운 ItemModel 생성
            final newItem = ItemModel(
              id: '', // Firestore에서 자동 생성될 ID
              title: '새로운 아이템', // 원하는 제목으로 변경 가능
              imageName: downloadURL.split('/').last, // 이미지 파일 이름 추출
            );

            // 2. Firestore에 아이템 추가
            final firestore = FirebaseFirestore.instance;
            final docRef =
                await firestore.collection('items').add(newItem.toFirestore());

            // 3. 아이템 ID 업데이트
            newItem.id = docRef.id;

            // 4. ViewModel의 items 리스트에 추가하고 UI 업데이트
            viewModel.items.add(newItem);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
