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

  // Get the current question
  String get currentQuestion => socratesQuestions[currentQuestionIndex];

  // Move to the next question
  void nextQuestion() {
    currentQuestionIndex =
        (currentQuestionIndex + 1) % socratesQuestions.length;
    notifyListeners();
  }

  // Save the answer to Firestore
  Future<void> saveAnswer(String answer) async {
    final String userId = ref.read(authRepositoryProvider).user!.uid;
    final Timestamp now = Timestamp.now();
    final ItemModel newItem = ItemModel(
      id: '', // Firestore에서 자동으로 ID 생성
      questionId: currentQuestionIndex.toString(),
      content: answer,
      createdAt: now,
    );

    await ref.read(itemRepositoryProvider).addItem(userId, newItem);
  }
}
