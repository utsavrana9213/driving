import 'package:get/get.dart';
import '../../Models/question_model.dart';

class QuestionController extends GetxController {
  final questions = <QuestionModel>[].obs;
  final currentIndex = 0.obs;
  final selectedOptions = <int, int>{}.obs; // Track selected option by question index
  final correctAnswers = 0.obs;
  final showAnswerFeedback = false.obs; // New reactive variable for immediate feedback

  void loadQuestions(List<QuestionModel> newQuestions) {
    questions.assignAll(newQuestions);
    currentIndex.value = 0;
    correctAnswers.value = 0;
    selectedOptions.clear();
    showAnswerFeedback.value = false;
  }

  void selectOption(int index) {
    final questionIndex = currentIndex.value;

    // Prevent selecting again if already answered
    if (selectedOptions.containsKey(questionIndex)) return;

    // Store the selected option
    selectedOptions[questionIndex] = index;
    showAnswerFeedback.value = true; // Trigger immediate feedback

    // Update correct answer count if the selected option is correct
    if (index == questions[questionIndex].correctAnswer) {
      correctAnswers.value++;
    }

    update(); // Force UI update
  }

  void nextQuestion() {
    showAnswerFeedback.value = false; // Reset feedback for new question
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void prevQuestion() {
    showAnswerFeedback.value = false; // Reset feedback for new question
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
}
