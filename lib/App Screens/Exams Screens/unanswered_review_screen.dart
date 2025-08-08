import 'package:avtoskola_varketilshi/App%20Screens/Home%20Screens/HomeScreen.dart';
import 'package:avtoskola_varketilshi/App%20Widegts/review_question_tile.dart';
import 'package:avtoskola_varketilshi/Controllers/Exams%20Controllers/review_controller.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnansweredReviewScreen extends StatelessWidget {
  const UnansweredReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());
    final unansweredController = Get.put(UnansweredQuestionsServices());

    // Clear answered questions when screen builds
    unansweredController.clearAnsweredQuestions();

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
                  GestureDetector(
                      onTap: () {
                        Get.to(HomeScreen());
                      },
                      child: Image.asset('assets/images/menu.png', height: 24)),
                  Image.asset('assets/images/slogo.png', height: 36),
                  Image.asset('assets/images/drawer.png', height: 24),
                ],
              ),
            ),
            unansweredController.unansweredQuestions.isNotEmpty
                ? Column(
                    children: [
                      const Text(
                        'You did not answer all questions',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Try again, we believe in you!',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : SizedBox.shrink(),

            /// List
            Expanded(
              child: Obx(() {
                if (unansweredController.unansweredQuestions.isEmpty) {
                  return Center(
                      child: Text(
                    'No unanswered questions found',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ));
                }
                return ListView.builder(
                  itemCount: unansweredController.unansweredQuestions.length,
                  itemBuilder: (context, index) {
                    final unansweredQuestion = unansweredController
                        .unansweredQuestions[index].unansweredQuestions;
                    return ReviewQuestionTile(
                      question: unansweredQuestion!,
                      questionIndex: index,
                      onToggle: () => controller.toggleExpand(index),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
