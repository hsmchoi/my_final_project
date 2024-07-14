import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/repositories/item_repository.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).user!.uid;
    final reflectionsStream =
        ref.watch(itemRepositoryProvider).getItemsStream(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reflections'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<ItemModel>>(
          stream: reflectionsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final reflections = snapshot.data ?? [];

            return ListView.builder(
              itemCount: reflections.length,
              itemBuilder: (context, index) {
                final reflection = reflections[index];
                return _buildReflectionCard(
                    context, ref, reflection); // context, ref 추가
              },
            );
          },
        ),
      ),
    );
  }

  // _buildReflectionCard 함수 인자 수정
  Widget _buildReflectionCard(
      BuildContext context, WidgetRef ref, ItemModel reflection) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(context, ref, reflection);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // Container를 사용하여 그라데이션 적용
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 237, 247, 255),
                Color.fromARGB(255, 237, 190, 152),
              ], // 원하는 색상으로 변경 가능
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '질문 : ${reflection.questionContent}',
              ),
              Text(
                '답변 : ${reflection.content}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _formatTimestamp(reflection.createdAt),
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _deleteReflection 함수 호출 시 context 전달
  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, ItemModel reflection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Are you sure you want to do this?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReflection(context, ref, reflection); // context 전달
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // _deleteReflection 함수 인자 수정
  Future<void> _deleteReflection(
      BuildContext context, WidgetRef ref, ItemModel reflection) async {
    final userId = ref.read(authRepositoryProvider).user!.uid;
    await ref.read(itemRepositoryProvider).deleteItem(userId, reflection.id);

    // context가 유효한 경우에만 Snackbar 표시
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection deleted!')),
      );
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
