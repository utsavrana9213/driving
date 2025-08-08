import 'package:avtoskola_varketilshi/Controllers/Exams%20Controllers/exam_controller.dart';
import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewQuestionTile extends StatelessWidget {
  final ExamQuestionModel question;
  final VoidCallback onToggle;
  final Function(int)? onAnswerSelected;
  final int questionIndex;

  const ReviewQuestionTile({
    super.key,
    required this.question,
    required this.onToggle,
    this.onAnswerSelected,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    final unansweredController = Get.put(UnansweredQuestionsServices());
    final examController = Get.find<ExamController>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text('#${question.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    (question.isExpanded ?? false)
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (question.isExpanded ?? false)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  question.question,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...List.generate(question.options.length, (i) {
                  final isCorrect = i == question.correctAnswer;
                  final isSelected = i == question.selectedIndex;
                  final isAnswered = question.selectedIndex != null;

                  Color backgroundColor = Colors.transparent;
                  Color borderColor = Colors.white;

                  if (isAnswered) {
                    if (isCorrect) {
                      backgroundColor = Colors.green.withOpacity(0.3);
                      borderColor = Colors.green;
                    } else if (isSelected) {
                      backgroundColor = Colors.red.withOpacity(0.3);
                      borderColor = Colors.red;
                    }
                  }

                  return GestureDetector(
                    onTap: isAnswered
                        ? null
                        : () {
                            // Handle answer selection
                            question.selectedIndex = i;

                            // Update the unanswered questions list
                            unansweredController.unansweredQuestions.refresh();

                            if (onAnswerSelected != null) {
                              onAnswerSelected!(i);
                            }

                            // Update the exam controller
                            examController.updateQuestion(question);
                          },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isAnswered && isCorrect
                                  ? Colors.green
                                  : isAnswered && isSelected
                                      ? Colors.red
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.options[i],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          if (isAnswered && isCorrect)
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 20),
                          if (isAnswered && isSelected && !isCorrect)
                            const Icon(Icons.cancel,
                                color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
      ],
    );
  }
}
