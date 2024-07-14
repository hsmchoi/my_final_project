//view_models/home_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/data/card/questions.dart';
import 'package:my_final_project/models/item_model.dart';

import '../repositories/authentication_repository.dart';
import '../repositories/item_repository.dart';

final homeViewModelProvider =
    ChangeNotifierProvider((ref) => HomeViewModel(ref));

class HomeViewModel extends ChangeNotifier {
  final Ref ref;
  int currentQuestionIndex = 0;

  HomeViewModel(this.ref);

  String get currentQuestion => socratesQuestions[currentQuestionIndex];

  void nextQuestion() {
    currentQuestionIndex =
        (currentQuestionIndex + 1) % socratesQuestions.length;
    notifyListeners();
  }

  Future<void> saveAnswer(String answer) async {
    final String userId = ref.read(authRepositoryProvider).user!.uid;
    final Timestamp now = Timestamp.now();
    final ItemModel newItem = ItemModel(
      id: '', // Firestore generates ID automatically
      questionId: currentQuestionIndex.toString(),
      content: answer,
      createdAt: now, questionContent: '',
    );

    await ref.read(itemRepositoryProvider).addItem(userId, newItem);
  }

  // StreamProvider for reflections
  final itemsStreamProvider =
      StreamProvider.autoDispose<List<ItemModel>>((ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final user = authRepository.user;
    if (user != null) {
      return ref.read(itemRepositoryProvider).getItemsStream(user.uid);
    } else {
      return Stream.value([]); // Or throw an error
    }
  });
}
