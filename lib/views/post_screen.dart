import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart'; // ItemModel import
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/repositories/item_repository.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).user!.uid;
    // StreamProvider for loading reflections from Firestore
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
                return _buildReflectionCard(reflection);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReflectionCard(ItemModel reflection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xFF87CEEB), // Light blue background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood: ${reflection.content}', // Display content as Mood
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
    );
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
