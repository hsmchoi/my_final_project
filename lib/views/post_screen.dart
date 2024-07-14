import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';
import 'package:my_final_project/repositories/item_repository.dart';
import 'package:my_final_project/view_models/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  String? _selectedFilter;
  String? _searchTerm;
  String _selectedSort = 'Date (Newest First)';

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final itemsAsyncValue = ref.watch(homeViewModel.itemsStreamProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(
          child: Text('Please log in to view your reflections.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reflections'),
      ),
      body: Column(
        children: [
          // Filtering and Sorting UI
          _buildFilterSortPanel(),
          // Reflections List
          Expanded(
            child: itemsAsyncValue.when(
              data: (items) {
                final filteredItems = items
                    .where((item) => item.userId == userId)
                    .toList(); // Filter by userId
                return filteredItems.isEmpty
                    ? const Center(child: Text('No reflections found.'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return _buildReflectionCard(context, item);
                        },
                      );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  // Filtering and Sorting Panel
  Widget _buildFilterSortPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Filter Dropdown
          DropdownButton<String>(
            value: _selectedFilter,
            hint: const Text('Filter by'),
            items: <String>['', 'Question 1', 'Question 2', 'Question 3']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue;
              });
            },
          ),
          const SizedBox(width: 16),
          // Search Field
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Sort Dropdown
          DropdownButton<String>(
            value: _selectedSort,
            items: <String>[
              'Date (Newest First)',
              'Date (Oldest First)',
              'Content (A-Z)',
              'Content (Z-A)'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSort = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  // Reflection Card Widget
  Widget _buildReflectionCard(BuildContext context, ItemModel item) {
    final dateTime = item.createdAt.toDate();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return GestureDetector(
      // 롱프레스 이벤트 리스너 추가
      onLongPress: () => _showDeleteConfirmationDialog(context, item),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.content,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 삭제 확인 대화상자 표시
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, ItemModel item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to do this?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자 닫기
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                // Firestore에서 항목 삭제
                await ref.read(itemRepositoryProvider).deleteItem(item.id);
                Navigator.of(context).pop(); // 대화상자 닫기
                // 삭제 성공 메시지 표시 (선택 사항)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reflection deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // 4. Function to Filter and Sort
  List<ItemModel> _filterAndSortItems(List<ItemModel> items) {
    // Filtering based on selected filter and search term
    var filteredItems = items.where((item) {
      // Simulating filter by question, replace with your actual logic
      final bool matchesFilter = _selectedFilter == null ||
          _selectedFilter == '' ||
          item.content.contains(_selectedFilter!);
      final bool matchesSearch = _searchTerm == null ||
          _searchTerm == '' ||
          item.content.toLowerCase().contains(_searchTerm!.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    // Sorting based on selected sort option
    switch (_selectedSort) {
      case 'Date (Newest First)':
        filteredItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Date (Oldest First)':
        filteredItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Content (A-Z)':
        filteredItems.sort((a, b) => a.content.compareTo(b.content));
        break;
      case 'Content (Z-A)':
        filteredItems.sort((a, b) => b.content.compareTo(a.content));
        break;
      default:
        break;
    }

    return filteredItems;
  }

  // // 5. Function to show delete confirmation dialog
  // Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  //   return await showDialog<bool>(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Delete Reflection'),
  //           content:
  //               const Text('Are you sure you want to delete this reflection?'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, false), // Cancel
  //               child: const Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, true), // Confirm
  //               child: const Text('Delete'),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false; // Return false if dialog is dismissed
  // }
}
