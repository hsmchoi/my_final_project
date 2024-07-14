import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/repositories/item_repository.dart';
import 'package:my_final_project/widgets/custom_background.dart'; // 배경 위젯 import
import 'package:my_final_project/widgets/wave_widget.dart'; // 파도 위젯 import
import 'package:go_router/go_router.dart'; // Import go_router

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final int _selectedIndex = 1; // Posts 화면의 인덱스는 1
  @override
  Widget build(BuildContext context) {
    // WidgetRef 제거
    // build 메서드 내에서 ref 사용 시, ref.watch() 사용
    final userId = ref.watch(authRepositoryProvider).user!.uid;
    final reflectionsStream =
        ref.watch(itemRepositoryProvider).getItemsStream(userId);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          // flexibleSpace를 사용하여 그라데이션 적용
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 239, 248, 255),
                Color.fromARGB(255, 239, 248, 255)
              ], // 원하는 색상으로 변경
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: WaveWidget(),
          ),
          Container(
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
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color.fromARGB(255, 255, 241, 241),
      //   elevation: 0,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         padding: const EdgeInsets.all(8.0),
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: Colors.white.withOpacity(0),
      //         ),
      //         child: const Icon(Icons.home, color: Colors.black),
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Container(
      //         padding: const EdgeInsets.all(8.0),
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: Colors.white.withOpacity(0),
      //         ),
      //         child: const Icon(Icons.article, color: Colors.black),
      //       ),
      //       label: 'Posts',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     if (index == 0) {
      //       context.go('/');
      //     } else if (index == 1) {
      //       context.go('/posts');
      //     }
      //   },
      // ),
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
                Color.fromARGB(255, 255, 241, 241),
                Color.fromARGB(255, 255, 241, 241)
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
