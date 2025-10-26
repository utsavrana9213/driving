import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Simple controller for managing expanded state
class SimpleReviewController extends GetxController {
  final expandedStates = <int, bool>{}.obs;
  
  void toggleExpand(int index) {
    expandedStates[index] = !(expandedStates[index] ?? false);
  }
  
  bool isExpanded(int index) {
    return expandedStates[index] ?? false;
  }
}

class UnansweredReviewScreen extends StatelessWidget {
  const UnansweredReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SimpleReviewController());
    final languageController = Get.find<LanguageController>();
    
    // Get questions from arguments if available, otherwise use UnansweredQuestionsServices
    final arguments = Get.arguments as Map<String, dynamic>?;
    final examQuestions = arguments?['examQuestions'] as List?;
    final category = arguments?['category'] as String?;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - App version or identifier
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '00\n00',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Center - Logo
                  Image.asset('assets/images/logo.png', height: 40),
                  
                  // Right side - Menu icon
                  GestureDetector(
                    onTap: () {
                      Get.to(HomeScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Message section
            Column(
              children: [
                const Text(
                  'Review Incorrect Answers',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category != null ? 'Category: $category' : 'Review questions you answered incorrectly',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),

            /// Questions List
            Expanded(
              child: _buildQuestionsList(examQuestions, controller, languageController),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuestionsList(List? examQuestions, controller, LanguageController languageController) {
    if (examQuestions != null && examQuestions.isNotEmpty) {
      // Use exam questions from arguments
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: examQuestions.length,
        itemBuilder: (context, index) {
          final question = examQuestions[index];
          return _buildModernQuestionCard(
            question: question,
            questionIndex: index,
            controller: controller,
            languageController: languageController,
          );
        },
      );
    } else {
      // No incorrect answers - perfect score!
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.celebration,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Perfect Score!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You answered all questions correctly.\nNo incorrect answers to review!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
  
  Widget _buildModernQuestionCard({
    required question,
    required int questionIndex,
    required SimpleReviewController controller,
    required LanguageController languageController,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() => Column(
        children: [
          // Question header with dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  '#${question.id}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => controller.toggleExpand(questionIndex),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      controller.isExpanded(questionIndex)
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Expanded content
          if (controller.isExpanded(questionIndex)) ...[
            // Question image
            if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(question.imageUrl!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Obx(() => Text(
                    question.getLocalizedQuestion(languageController.currentLanguageCode),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
            
            // Question text (if no image)
            if (question.imageUrl == null || question.imageUrl!.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Obx(() => Text(
                  question.getLocalizedQuestion(languageController.currentLanguageCode),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            
            // Answer options
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(question.options.length, (i) {
                  final isCorrect = i == question.correctAnswer;
                  final isSelected = i == question.selectedIndex;
                  final isAnswered = question.selectedIndex != null;

                  Color backgroundColor = Colors.grey.shade100;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.black87;

                  // Always show correct answer in green
                  if (isCorrect) {
                    backgroundColor = Colors.green.shade100;
                    borderColor = Colors.green;
                    textColor = Colors.green.shade800;
                  } else if (isAnswered && isSelected) {
                    // Show user's wrong selection in red only if they answered
                    backgroundColor = Colors.red.shade100;
                    borderColor = Colors.red;
                    textColor = Colors.red.shade800;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green
                                : isAnswered && isSelected
                                    ? Colors.red
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Text(
                            question.getLocalizedOptions(languageController.currentLanguageCode)[i],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ),
                        if (isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        if (isAnswered && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    ));
  }
}
