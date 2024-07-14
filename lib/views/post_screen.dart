import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/models/item_model.dart';
import 'package:my_final_project/view_models/home_view_model.dart';
import 'package:intl/intl.dart';

class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  // 1. Add variables to manage filtering and sorting
  String? _selectedFilter;
  String? _searchTerm;
  String _selectedSort = 'Date (Newest First)';

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final itemsAsyncValue = homeViewModel.itemsStreamProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reflections'),
      ),
      body: Column(
        children: [
          // 2. Add UI for Filtering and Sorting
          Padding(
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
          ),
          // 3. Filtered and Sorted Reflections List
          Expanded(
            child: itemsAsyncValue.when(
              data: (items) {
                // Apply filtering and sorting
                final filteredItems = _filterAndSortItems(items);
                if (filteredItems.isEmpty) {
                  return const Center(child: Text('No matching reflections.'));
                } else {
                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final dateTime = item.createdAt.toDate();
                      final formattedDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                      return Card(
                        child: ListTile(
                          title: Text(item.content),
                          subtitle: Text(formattedDate),
                        ),
                      );
                    },
                  );
                }
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
}
