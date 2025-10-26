import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EnhancedExamController extends GetxController {
  // Core exam data
  final allQuestions = <ExamQuestionModel>[].obs;
  final examQuestions = <ExamQuestionModel>[].obs;
  final skippedQuestions = <ExamQuestionModel>[].obs;
  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;
  final incorrectAnswers = <ExamQuestionModel>[].obs;
  
  // Exam configuration based on category
  final RxInt totalQuestions = 30.obs;
  final RxInt maxIncorrectAnswers = 3.obs;
  final RxInt examDuration = (30 * 60).obs; // 30 minutes in seconds
  
  // Exam state
  final RxInt remainingTime = (30 * 60).obs;
  final RxInt correctAnswersCount = 0.obs;
  final RxInt wrongAnswersCount = 0.obs;
  final RxBool isExamFailed = false.obs;
  final RxBool isExamPassed = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool showingAnswer = false.obs;
  final RxString currentCategory = ''.obs;
  
  Timer? _timer;
  Timer? _answerDelayTimer;
  
  @override
  void onInit() {
    super.onInit();
    selectedAnswers.clear();
    final category = Get.arguments as String? ?? 'B, B1';
    currentCategory.value = category;
    configureExamByCategory(category);
    loadQuestions(category);
    startTimer();
  }
  
  void configureExamByCategory(String category) {
    switch (category) {
      case 'B, B1':
      case 'T, S':
        totalQuestions.value = 30;
        maxIncorrectAnswers.value = 3;
        examDuration.value = 30 * 60; // 30 minutes
        remainingTime.value = 30 * 60;
        break;
      case 'C':
      case 'D':
        totalQuestions.value = 40;
        maxIncorrectAnswers.value = 4;
        examDuration.value = 30 * 60; // 30 minutes
        remainingTime.value = 30 * 60;
        break;
      default:
        totalQuestions.value = 30;
        maxIncorrectAnswers.value = 3;
        examDuration.value = 30 * 60;
        remainingTime.value = 30 * 60;
    }
  }
  
  Future<List<ExamQuestionModel>> loadAllQuestions(String questionFile) async {
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
    List<String> questionFiles = [];
    
    // Try multiple file paths for each category
    switch (category) {
      case 'B, B1':
        questionFiles = [
          'assets/questions/b-b1/B,B1_exam.json',
          'assets/questions/B,B1_exam.json',
          'assets/questions/b_b1_category.json',
        ];
        break;
      case 'C':
        questionFiles = [
          'assets/questions/c/c_category.json',
          'assets/questions/c_category.json',
        ];
        break;
      case 'D':
        questionFiles = [
          'assets/questions/d/d_category.json',
          'assets/questions/d_category.json',
        ];
        break;
      case 'T, S':
        questionFiles = [
          'assets/questions/t-s/t_s_category.json',
          'assets/questions/t_s_category.json',
        ];
        break;
      default:
        questionFiles = [
          'assets/questions/B,B1_exam.json',
          'assets/questions/b_b1_category.json',
        ];
    }
    
    List<ExamQuestionModel> loadedQuestions = [];
    
    // Try each file path until we find questions
    for (String file in questionFiles) {
      try {
        loadedQuestions = await loadAllQuestions(file);
        if (loadedQuestions.isNotEmpty) {
          log("Successfully loaded questions from: $file for category: $category");
          break;
        }
      } catch (e) {
        log("Failed to load from $file: $e");
        continue;
      }
    }
    
    if (loadedQuestions.isEmpty) {
      log("ERROR: No questions found for category: $category");
      Get.snackbar(
        'Error',
        'No questions available for $category category',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      isLoading.value = false;
      return;
    }
    
    allQuestions.assignAll(loadedQuestions);
    
    // Randomly select questions for the exam
    final shuffled = List<ExamQuestionModel>.from(allQuestions)..shuffle();
    var selectedQuestions = shuffled.take(totalQuestions.value).toList();
    
    // Fix image paths for category-specific images
    selectedQuestions = _fixImagePaths(selectedQuestions, category);
    
    examQuestions.assignAll(selectedQuestions);
    
    log("Loaded ${examQuestions.length} questions for exam in category: $category");
    isLoading.value = false;
  }
  
  List<ExamQuestionModel> _fixImagePaths(List<ExamQuestionModel> questionsList, String category) {
    // Fix image paths to be category-specific
    String imageFolder = '';
    int maxImages = 3; // Default number of images available
    
    switch (category) {
      case 'B, B1':
        imageFolder = 'B';
        maxImages = 3; // B folder has q1.png, q2.png, q3.png
        break;
      case 'C':
        imageFolder = 'C';
        maxImages = 1; // C folder might have fewer images, fallback to B
        break;
      case 'D':
        imageFolder = 'D';
        maxImages = 1; // D folder might have fewer images, fallback to B
        break;
      case 'T, S':
        imageFolder = 'TS';
        maxImages = 4; // TS folder has q1.png to q4.png
        break;
      default:
        imageFolder = 'B';
        maxImages = 3;
    }
    
    // Update image paths for each question
    for (int i = 0; i < questionsList.length; i++) {
      final question = questionsList[i];
      
      // Generate unique image path based on question ID and category
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        String imagePath;
        
        // Try category-specific images first
        if (imageFolder == 'C' || imageFolder == 'D') {
          // For C and D, since folders don't exist, use B folder images
          final imageIndex = (question.id % 3) + 1; // Use B folder images (3 available)
          imagePath = 'assets/Qimages/B/q$imageIndex.png';
          log("Using B folder image for $category category");
        } else {
          // For B,B1 and T,S use their own folders
          final imageIndex = (question.id % maxImages) + 1;
          imagePath = 'assets/Qimages/$imageFolder/q$imageIndex.png';
        }
        
        // If the specific path doesn't work, fallback to generic image
        if (imagePath.isEmpty) {
          imagePath = 'assets/images/1.png'; // Fallback to available generic image
        }
        
        // Update the question with new image path
        questionsList[i] = ExamQuestionModel(
          id: question.id,
          question: question.question,
          options: question.options,
          correctAnswer: question.correctAnswer,
          previewVideo: question.previewVideo,
          correctVideo: question.correctVideo,
          wrongVideo: question.wrongVideo,
          imageUrl: imagePath,
          isExpanded: question.isExpanded,
          selectedIndex: question.selectedIndex,
        );
        
        log("Exam Q${question.id} (${category}): $imagePath");
      }
    }
    
    return questionsList;
  }
  
  void selectOption(int optionIndex) {
    if (showingAnswer.value) return;
    
    final currentQuestion = examQuestions[currentIndex.value];
    selectedAnswers[currentIndex.value] = optionIndex;
    currentQuestion.selectedIndex = optionIndex;
    
    // Show answer feedback
    showingAnswer.value = true;
    
    if (optionIndex == currentQuestion.correctAnswer) {
      correctAnswersCount.value++;
    } else {
      wrongAnswersCount.value++;
      incorrectAnswers.add(currentQuestion);
      
      // Check if exam should fail
      if (wrongAnswersCount.value > maxIncorrectAnswers.value) {
        failExam();
        return;
      }
    }
    
    // Auto-transition to next question after 2 seconds
    _answerDelayTimer?.cancel();
    _answerDelayTimer = Timer(const Duration(seconds: 2), () {
      showingAnswer.value = false;
      moveToNextQuestion();
    });
  }
  
  void skipQuestion() {
    if (showingAnswer.value) return;
    
    final currentQuestion = examQuestions[currentIndex.value];
    
    // Add to skipped questions if not already skipped
    if (!skippedQuestions.contains(currentQuestion)) {
      skippedQuestions.add(currentQuestion);
      // Remove from current position
      examQuestions.removeAt(currentIndex.value);
      // Add to the end
      examQuestions.add(currentQuestion);
    } else {
      // If already skipped, just move to next
      moveToNextQuestion();
    }
  }
  
  void moveToNextQuestion() {
    if (currentIndex.value < examQuestions.length - 1) {
      currentIndex.value++;
    } else {
      // Check if exam is complete
      checkExamCompletion();
    }
  }
  
  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
  
  void checkExamCompletion() {
    // Automatically redirect to review page when all questions are completed
    // (either answered or reached the end of the question list)
    navigateToPreviewScreen();
  }
  
  void navigateToPreviewScreen() {
    _timer?.cancel();
    _answerDelayTimer?.cancel();
    
    // Navigate to the preview/review screen with questions as arguments
    Get.offNamed('/unanswered-review', arguments: {
      'examQuestions': examQuestions,
      'category': currentCategory.value,
    });
  }
  
  void failExam() {
    isExamFailed.value = true;
    _timer?.cancel();
    _answerDelayTimer?.cancel();
    Get.offNamed('/exam-fail', arguments: {
      'incorrectAnswers': incorrectAnswers,
      'totalQuestions': examQuestions.length,
      'correctAnswers': correctAnswersCount.value,
      'category': currentCategory.value,
      'examQuestions': examQuestions, // Pass exam questions for review
    });
  }
  
  void passExam() {
    isExamPassed.value = true;
    _timer?.cancel();
    _answerDelayTimer?.cancel();
    Get.offNamed('/exam-pass', arguments: {
      'totalQuestions': examQuestions.length,
      'correctAnswers': correctAnswersCount.value,
      'incorrectAnswers': incorrectAnswers, // Pass incorrect answers list for review
      'category': currentCategory.value,
      'timeSpent': examDuration.value - remainingTime.value,
      'examQuestions': examQuestions, // Keep all questions for other purposes
    });
  }
  
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        // Time's up - fail the exam
        failExam();
      }
    });
  }
  
  @override
  void onClose() {
    _timer?.cancel();
    _answerDelayTimer?.cancel();
    super.onClose();
  }
  
  String get formattedTime {
    final minutes = remainingTime.value ~/ 60;
    final seconds = remainingTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Check if an option is the correct answer
  bool isCorrectAnswer(int questionIndex, int optionIndex) {
    if (!showingAnswer.value || questionIndex != currentIndex.value) return false;
    return examQuestions[questionIndex].correctAnswer == optionIndex;
  }
  
  // Check if an option was selected and is wrong
  bool isWrongAnswer(int questionIndex, int optionIndex) {
    if (!showingAnswer.value || questionIndex != currentIndex.value) return false;
    final selected = selectedAnswers[questionIndex];
    if (selected == null) return false;
    return selected == optionIndex && selected != examQuestions[questionIndex].correctAnswer;
  }
  
  // Check if an option was selected
  bool isSelected(int questionIndex, int optionIndex) {
    final selected = selectedAnswers[questionIndex];
    return selected == optionIndex;
  }
  
  // Get current question
  ExamQuestionModel? get currentQuestion {
    if (examQuestions.isEmpty || currentIndex.value >= examQuestions.length) {
      return null;
    }
    return examQuestions[currentIndex.value];
  }
  
  // Check if can skip current question
  bool get canSkipQuestion {
    return !showingAnswer.value && 
           currentIndex.value < examQuestions.length - 1 &&
           !selectedAnswers.containsKey(currentIndex.value);
  }
  
  // Get progress percentage
  double get progressPercentage {
    if (examQuestions.isEmpty) return 0.0;
    return selectedAnswers.length / examQuestions.length;
  }
}
