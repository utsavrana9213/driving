import 'package:avtoskola_varketilshi/Controllers/Subject%20Controllers/question_controller.dart';
import 'package:avtoskola_varketilshi/Models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionController());
    final questions = Get.arguments as List<QuestionModel>;
    controller.loadQuestions(questions);

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No questions available for this subject.',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          final questionIndex = controller.currentIndex.value;
          final question = controller.questions[questionIndex];
          final hasAnswered =
              controller.selectedOptions.containsKey(questionIndex);
          final showFeedback = controller.showAnswerFeedback.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${questionIndex + 1}/${controller.questions.length}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Image.asset('assets/images/slogo.png', height: 38),
                    Text(
                      '${controller.correctAnswers.value}/${controller.questions.length}',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Question

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: question.imageUrl != null
                      ? Image.asset(question.imageUrl!)
                      : SizedBox.shrink(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),

              /// Options
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final isSelected =
                        controller.selectedOptions[questionIndex] == index;
                    final isCorrect = index == question.correctAnswer;

                    Color optionColor = Colors.transparent;
                    if (isSelected) {
                      optionColor = isCorrect ? Colors.green : Colors.red;
                    }
                    // Show correct answer if feedback is enabled
                    else if ((showFeedback || hasAnswered) && isCorrect) {
                      optionColor = Colors.green.withOpacity(0.3);
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: optionColor,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        title: Text(
                          question.options[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          if (!hasAnswered) {
                            controller.selectOption(index);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              /// Bottom Navigation
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.red)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.error, color: Colors.red),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          onPressed: controller.prevQuestion,
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: controller.nextQuestion,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
