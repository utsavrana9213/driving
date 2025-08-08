import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:avtoskola_varketilshi/App%20Widegts/showTestPassedDialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExamController extends GetxController {
  final questions = <ExamQuestionModel>[].obs;
  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;
  final RxInt remainingTime = (30 * 60).obs;
  final RxInt correctAnswersCount = 0.obs;
  final RxInt wrongAnswersCount = 0.obs;
  final answeredQuestions = <int>{}.obs;
  Timer? _timer;
  final RxBool playVideoFlag = false.obs;
  final RxBool isLoading = true.obs;

  final RxString currentVideo = ''.obs;
  final RxBool videoPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedAnswers.clear();
    final category = Get.arguments as String? ?? 'B, B1';
    loadQuestions(category);
    startTimer();
  }

  Future<List<ExamQuestionModel>> loadExamQuestions(String questionFile) async {
    try {
      final String jsonString = await rootBundle.loadString(questionFile);
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .map((questionJson) => ExamQuestionModel.fromJson(questionJson))
          .toList();
    } catch (e) {
      log("Error loading questions: $e");
      return [];
    }
  }

  void loadQuestions(String category) async {
    isLoading.value = true;
    String questionFile;

    switch (category) {
      case 'B, B1':
        questionFile = 'assets/questions/B,B1_exam.json';
        break;
      case 'C':
        questionFile = 'assets/questions/c_category.json';
        break;
      case 'D':
        questionFile = 'assets/questions/d_category.json';
        break;
      case 'T, S':
        questionFile = 'assets/questions/t_s_category.json';
        break;
      default:
        questionFile = 'assets/questions/b_b1_category.json'; // fallback
    }

    final loadedQuestions = await loadExamQuestions(questionFile);
    questions.assignAll(loadedQuestions);
    isLoading.value = false;
    if (questions.isNotEmpty) {
      _updateCurrentVideoForQuestion(currentIndex.value);
    }
  }

  void _updateCurrentVideoForQuestion(int index) {
    if (index < 0 || index >= questions.length) return;

    final question = questions[index];
    if (selectedAnswers.containsKey(index)) {
      final selectedOption = selectedAnswers[index];
      if (selectedOption == question.correctAnswer) {
        currentVideo.value = question.correctVideo ?? '';
      } else {
        currentVideo.value = question.wrongVideo ?? '';
      }
      hasAnsweredCurrentQuestion.value = true;
      videoPlaying.value = currentVideo.value.isNotEmpty;
    } else {
      currentVideo.value = question.previewVideo ?? '';
      hasAnsweredCurrentQuestion.value = false;
      videoPlaying.value = false; // Preview video should not autoplay
    }
  }

  void selectOption(int optionIndex) {
    final currentQuestion = questions[currentIndex.value];
    selectedAnswers[currentIndex.value] = optionIndex;
    answeredQuestions.add(currentIndex.value);

    // Update the selectedIndex on the current question
    currentQuestion.selectedIndex = optionIndex;

    if (optionIndex == currentQuestion.correctAnswer) {
      correctAnswersCount.value++;
      currentVideo.value =
          currentQuestion.correctVideo ?? ''; // Set correct video
    } else {
      wrongAnswersCount.value++;
      currentVideo.value = currentQuestion.wrongVideo ?? ''; // Set wrong video
    }

    hasAnsweredCurrentQuestion.value = true;

    // Trigger video playback
    if (currentVideo.value.isNotEmpty) {
      videoPlaying.value = true;
    }

    // Proceed to next question after 7 seconds, only if an option is selected
    Future.delayed(const Duration(seconds: 7), () {
      nextQuestionWithDelay();
    });
  }

  void onVideoEnd() {
    videoPlaying.value = false;
    currentVideo.value = ''; // Clear the video path after it has finished
  }

  final RxBool hasAnsweredCurrentQuestion = false.obs;

  void nextQuestionWithDelay() {
    if (selectedAnswers[currentIndex.value] != null) {
      // Only proceed if an option is selected
      if (currentIndex.value < questions.length - 1) {
        currentIndex.value++;
        _updateCurrentVideoForQuestion(currentIndex.value);
      }
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentIndex.value = index;
      _updateCurrentVideoForQuestion(index);
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      _updateCurrentVideoForQuestion(currentIndex.value);
    } else if (currentIndex.value == questions.length - 1) {
      // User is on the last question and clicked next - show test passed dialog
      showTestPassedDialog(
        Get.context!,
        totalQuestions: questions.length,
        answeredQuestions: selectedAnswers.length,
        correctAnswers: correctAnswersCount.value,
      );
    }
  }

  void prevQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      _updateCurrentVideoForQuestion(currentIndex.value);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get formattedTime {
    final minutes = remainingTime.value ~/ 60;
    final seconds = remainingTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool isCorrect(int index) =>
      selectedAnswers[currentIndex.value] != null &&
      selectedAnswers[currentIndex.value] ==
          questions[currentIndex.value].correctAnswer &&
      selectedAnswers[currentIndex.value] == index;

  bool isWrong(int index) =>
      selectedAnswers[currentIndex.value] != null &&
      selectedAnswers[currentIndex.value] !=
          questions[currentIndex.value].correctAnswer &&
      selectedAnswers[currentIndex.value] == index;

  bool get canGoNext => selectedAnswers[currentIndex.value] != null;
  bool get canGoPrev =>
      currentIndex.value > 0 && !answeredQuestions.contains(currentIndex.value);

  /// Check if the previous question is answered or not
  bool isPreviousQuestionAnswered() {
    final previousIndex = currentIndex.value - 1;
    return previousIndex >= 0 && answeredQuestions.contains(previousIndex);
  }

  bool isQuestionAnswered(int questionIndex) {
    return answeredQuestions.contains(questionIndex);
  }

  void syncAnsweredQuestionsFromReview() {
    final unansweredController = Get.find<UnansweredQuestionsServices>();
    final unansweredQuestions = unansweredController.unansweredQuestions;
    
    for (var unansweredQ in unansweredQuestions) {
      final question = unansweredQ.unansweredQuestions;
      if (question != null && question.selectedIndex != null) {
        final questionIndex = questions.indexWhere((q) => q.id == question.id);
        if (questionIndex != -1) {
          selectedAnswers[questionIndex] = question.selectedIndex!;
          answeredQuestions.add(questionIndex);
          
          questions[questionIndex].selectedIndex = question.selectedIndex;
        }
      }
    }
    
    // Update the current question's video if needed
    _updateCurrentVideoForQuestion(currentIndex.value);
  }

  /// Update a specific question when answered from review screen
  void updateQuestion(ExamQuestionModel updatedQuestion) {
    final questionIndex = questions.indexWhere((q) => q.id == updatedQuestion.id);
    if (questionIndex != -1 && updatedQuestion.selectedIndex != null) {
      // Update the selectedAnswers map
      selectedAnswers[questionIndex] = updatedQuestion.selectedIndex!;
      answeredQuestions.add(questionIndex);
      
      // Update the question in the questions list
      questions[questionIndex].selectedIndex = updatedQuestion.selectedIndex;
      
      // Update the current question's video if this is the current question
      if (questionIndex == currentIndex.value) {
        _updateCurrentVideoForQuestion(currentIndex.value);
      }
    }
  }

  /// Check if the exam is completed (all questions answered)
  bool get isExamCompleted {
    return selectedAnswers.length == questions.length;
  }

  /// Check if we're on the last question and it's been answered
  bool get isLastQuestionCompleted {
    final isLastQuestion = currentIndex.value == questions.length - 1;
    final isLastQuestionAnswered = selectedAnswers.containsKey(currentIndex.value);
    return isLastQuestion && isLastQuestionAnswered;
  }
}
