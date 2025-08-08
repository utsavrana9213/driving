import 'dart:developer';

import 'package:avtoskola_varketilshi/Models/unanswered_questions_model.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UnansweredQuestionsServices extends GetxController {
  Box<UnansweredQuestionsModel>? _unansweredQuestionsBox;
  var unansweredQuestions = <UnansweredQuestionsModel>[].obs;
  var isLoading = false.obs;
  var answeredQuestions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    clearUnansweredQuestionsBox();
    getUnansweredQuestions();
  }

  Future<void> openUnansweredQuestionsBox() async {
    if (_unansweredQuestionsBox == null || !_unansweredQuestionsBox!.isOpen) {
      _unansweredQuestionsBox = await Hive.openBox<UnansweredQuestionsModel>(
          'unanswered questions box');
    }
    log(_unansweredQuestionsBox!.name);
  }

  Future<void> closeUnansweredQuestionBox() async {
    if (_unansweredQuestionsBox != null && _unansweredQuestionsBox!.isOpen) {
      await _unansweredQuestionsBox!.close();
    }
  }

  Future<void> addUnansweredQuestion(
      {required UnansweredQuestionsModel question}) async {
    try {
      if (_unansweredQuestionsBox == null || _unansweredQuestionsBox!.isEmpty) {
        await openUnansweredQuestionsBox();
      }
      await _unansweredQuestionsBox!.add(question);
      log('unanswered Question added');
      await getUnansweredQuestions();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUnansweredQuestions() async {
    try {
      await openUnansweredQuestionsBox();
      isLoading.value = true;
      update();
      unansweredQuestions.value = _unansweredQuestionsBox!.values.toList();
      isLoading.value = false;
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteQuestion(int index) async {
    try {
      await openUnansweredQuestionsBox();
      await _unansweredQuestionsBox!.deleteAt(index);
      await getUnansweredQuestions();
      log('question deleted');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteQuestionById(int questionId) async {
    try {
      await openUnansweredQuestionsBox();
      final questions = _unansweredQuestionsBox!.values.toList();
      final indexToDelete = questions.indexWhere((q) => q.unansweredQuestions?.id == questionId);
      if (indexToDelete != -1) {
        await _unansweredQuestionsBox!.deleteAt(indexToDelete);
        await getUnansweredQuestions();
        log('question with id $questionId deleted');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> clearAnsweredQuestions() async {
    try {
      await openUnansweredQuestionsBox();
      final questions = _unansweredQuestionsBox!.values.toList();
      final answeredQuestions = questions.where((q) => 
        q.unansweredQuestions?.selectedIndex != null
      ).toList();
      
      for (var answeredQuestion in answeredQuestions) {
        final indexToDelete = questions.indexWhere((q) => 
          q.unansweredQuestions?.id == answeredQuestion.unansweredQuestions?.id
        );
        if (indexToDelete != -1) {
          await _unansweredQuestionsBox!.deleteAt(indexToDelete);
        }
      }
      
      await getUnansweredQuestions();
      log('${answeredQuestions.length} answered questions cleared');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> clearUnansweredQuestionsBox() async {
    try {
      await openUnansweredQuestionsBox();
      await _unansweredQuestionsBox!.clear();
      await getUnansweredQuestions();
      log('unanswered questions box cleared');
    } catch (e) {
      log(e.toString());
    }
  }
}
