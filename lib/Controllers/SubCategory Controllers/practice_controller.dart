import 'dart:convert';
import 'dart:developer';
import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Models/subcategory_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PracticeController extends GetxController {
  // Questions and navigation
  final questions = <ExamQuestionModel>[].obs;
  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;
  
  // Score tracking (no fail condition in practice mode)
  final RxInt correctAnswersCount = 0.obs;
  final RxInt wrongAnswersCount = 0.obs;
  final RxInt totalAnswered = 0.obs;
  
  // UI state
  final RxBool isLoading = true.obs;
  final RxBool showingAnswer = false.obs;
  
  // Sub-category info
  late SubCategoryModel subCategory;
  late String category;
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    subCategory = args['subCategory'];
    category = args['category'] ?? 'B, B1';
    loadSubCategoryQuestions();
  }
  
  // Method to force reload questions (useful after JSON changes)
  void forceReloadQuestions() {
    log("🔄 Force reloading questions for ${subCategory.nameEn}");
    loadSubCategoryQuestions();
  }

  // Getters for UI
  ExamQuestionModel get currentQuestion => questions[currentIndex.value];
  bool get isCurrentQuestionAnswered => selectedAnswers.containsKey(currentIndex.value);
  double get progressPercentage => questions.isEmpty ? 0.0 : (currentIndex.value + 1) / questions.length;
  double get scorePercentage => totalAnswered.value == 0 ? 0.0 : (correctAnswersCount.value / totalAnswered.value) * 100;
  
  Future<List<ExamQuestionModel>> loadQuestionsFromFile(String questionFile) async {
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
  
  void loadSubCategoryQuestions() async {
    isLoading.value = true;
    String questionFile = '';
    
    // Map subcategory IDs to actual question files based on category
    questionFile = _getSubCategoryQuestionFile(category, subCategory.id);
    
    try {
      // Load questions from the specific subcategory file
      List<ExamQuestionModel> subcategoryQuestions = await loadQuestionsFromFile(questionFile);
      
      if (subcategoryQuestions.isEmpty) {
        // If specific file not found, try loading from main exam file
        log("No questions in specific file, trying main exam file");
        subcategoryQuestions = await _loadFromMainExamFile(category);
      }
      
      if (subcategoryQuestions.isNotEmpty) {
        // Take the appropriate number of questions for this subcategory
        if (subcategoryQuestions.length > subCategory.questionCount) {
          subcategoryQuestions.shuffle();
          subcategoryQuestions = subcategoryQuestions.take(subCategory.questionCount).toList();
        }
        
        // Fix image paths for category-specific images
        subcategoryQuestions = _fixImagePaths(subcategoryQuestions, category);
        
        questions.assignAll(subcategoryQuestions);
        log("Loaded ${questions.length} questions for subcategory: ${subCategory.nameEn}");
      } else {
        log("No questions found for subcategory: ${subCategory.nameEn}");
        Get.snackbar(
          'Error',
          'No questions available for this subcategory',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error loading subcategory questions: $e");
      // Try loading from main exam file as fallback
      final fallbackQuestions = await _loadFromMainExamFile(category);
      if (fallbackQuestions.isNotEmpty) {
        fallbackQuestions.shuffle();
        var questionsToUse = fallbackQuestions.take(subCategory.questionCount).toList();
        questionsToUse = _fixImagePaths(questionsToUse, category);
        questions.assignAll(questionsToUse);
      }
    }
    
    isLoading.value = false;
  }
  
  List<ExamQuestionModel> _fixImagePaths(List<ExamQuestionModel> questionsList, String category) {
    // IMPORTANT: This method now preserves custom images from JSON
    // Only generates default paths for questions without custom images
    
    String imageFolder = '';
    
    switch (category) {
      case 'B, B1':
        imageFolder = 'B';
        break;
      case 'C':
        imageFolder = 'C';
        break;
      case 'D':
        imageFolder = 'D';
        break;
      case 'T, S':
        imageFolder = 'TS';
        break;
      default:
        imageFolder = 'B';
    }
    
    // Process each question
    for (int i = 0; i < questionsList.length; i++) {
      final question = questionsList[i];
      
      // Check if question already has a custom imageUrl from JSON
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        // Keep ANY custom image path from JSON as-is
        // This allows you to use any image path you want
        log("✅ Q${question.id} using custom image: ${question.imageUrl}");
        // DON'T modify the question - keep the original image
        continue;
      }
      
      // Only generate a default image if NO custom image is specified
      log("⚠️ Q${question.id} has no image, generating default");
      
      // Generate a unique default image path based on question ID
      // This ensures each question gets a different default image
      String imagePath = 'assets/Qimages/$imageFolder/q${question.id}.png';
      
      // Update ONLY questions without custom images
      questionsList[i] = ExamQuestionModel(
        id: question.id,
        question: question.question,
        options: question.options,
        correctAnswer: question.correctAnswer,
        previewVideo: question.previewVideo,
        correctVideo: question.correctVideo,
        wrongVideo: question.wrongVideo,
        imageUrl: imagePath, // Use the generated path
        isExpanded: question.isExpanded,
        selectedIndex: question.selectedIndex,
        questionEn: question.questionEn,
        optionsEn: question.optionsEn,
      );
      
      log("📸 Generated default image for Q${question.id}: $imagePath");
    }
    
    return questionsList;
  }
  
  String _getSubCategoryQuestionFile(String category, int subcategoryId) {
    // Map subcategory IDs to actual file names based on what we found in the assets
    String folder = '';
    String filename = '';
    
    switch (category) {
      case 'B, B1':
        folder = 'b-b1';
        // Map subcategory IDs to B,B1 files
        switch (subcategoryId) {
          case 1: filename = 'bb1_law.json'; break; // Traffic Rules
          case 2: filename = 'bb1_sign_conventions.json'; break; // Road Signs
          case 3: filename = 'bb1_warning_signs.json'; break; // Warning Signs
          case 4: filename = 'bb1_priority_signs.json'; break; // Priority Signs
          case 5: filename = 'bb1_prohobitory_signs.json'; break; // Prohibition Signs
          case 6: filename = 'bb1_regulator_signs.json'; break; // Mandatory Signs
          default: filename = 'bb1_law.json'; // Default fallback
        }
        break;
      case 'C':
        folder = 'c';
        filename = 'c_law.json'; // Use general C category file
        break;
      case 'D':
        folder = 'd';
        filename = 'd_law.json'; // Use general D category file
        break;
      case 'T, S':
        folder = 't-s';
        filename = 'ts_law.json'; // Use general T,S category file
        break;
      default:
        folder = 'b-b1';
        filename = 'bb1_law.json';
    }
    
    return 'assets/questions/$folder/$filename';
  }

  // Navigation methods
  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      showingAnswer.value = false;
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      showingAnswer.value = false;
    }
  }

  // Answer selection and checking methods
  void selectOption(int optionIndex) {
    if (showingAnswer.value) return;
    
    // Check if this is a new answer (not previously answered)
    final wasAnswered = selectedAnswers.containsKey(currentIndex.value);
    
    selectedAnswers[currentIndex.value] = optionIndex;
    showingAnswer.value = true;
    
    // Update counters only for new answers
    if (!wasAnswered) {
      final question = questions[currentIndex.value];
      final isCorrect = optionIndex == question.correctAnswer - 1; // correctAnswer is 1-indexed
      
      totalAnswered.value++;
      if (isCorrect) {
        correctAnswersCount.value++;
      } else {
        wrongAnswersCount.value++;
      }
    }
  }

  bool isSelected(int questionIndex, int optionIndex) {
    return selectedAnswers[questionIndex] == optionIndex;
  }

  bool isCorrectAnswer(int questionIndex, int optionIndex) {
    if (!showingAnswer.value) return false;
    final question = questions[questionIndex];
    return optionIndex == question.correctAnswer - 1; // correctAnswer is 1-indexed
  }

  bool isWrongAnswer(int questionIndex, int optionIndex) {
    if (!showingAnswer.value) return false;
    final selectedAnswer = selectedAnswers[questionIndex];
    final question = questions[questionIndex];
    return selectedAnswer == optionIndex && optionIndex != question.correctAnswer - 1;
  }

  void resetPractice() {
    currentIndex.value = 0;
    selectedAnswers.clear();
    correctAnswersCount.value = 0;
    wrongAnswersCount.value = 0;
    totalAnswered.value = 0;
    showingAnswer.value = false;
    
    // Clear selected indices from questions
    for (var question in questions) {
      question.selectedIndex = null;
    }
  }

  // Helper method for fallback loading
  Future<List<ExamQuestionModel>> _loadFromMainExamFile(String category) async {
    try {
      String mainFile = '';
      switch (category) {
        case 'B, B1':
          mainFile = 'assets/questions/b-b1/bb1_law.json';
          break;
        case 'C':
          mainFile = 'assets/questions/c/c_law.json';
          break;
        case 'D':
          mainFile = 'assets/questions/d/d_law.json';
          break;
        case 'T, S':
          mainFile = 'assets/questions/t-s/ts_law.json';
          break;
        default:
          mainFile = 'assets/questions/b-b1/bb1_law.json';
      }
      return await loadQuestionsFromFile(mainFile);
    } catch (e) {
      log("Error loading main exam file: $e");
      return [];
    }
  }
}
