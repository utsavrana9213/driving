import 'package:flutter/material.dart';
import 'package:avtoskola_varketilshi/App Screens/Exams Screens/unanswered_review_screen.dart';
import 'package:get/get.dart';

void showTestPassedDialog(
  BuildContext context, {
  required int totalQuestions,
  required int answeredQuestions,
  required int correctAnswers,
}) {
  // Calculate completion and performance
  final isAllQuestionsAnswered = answeredQuestions == totalQuestions;
  final correctPercentage =
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
  final isPassed = correctPercentage >= 50;

  // Determine dialog content based on conditions
  String title;
  String subtitle;
  String buttonText;
  VoidCallback? onButtonPressed;

  if (!isAllQuestionsAnswered) {
    // Not all questions answered
    title = 'Please answer all questions';
    subtitle =
        'You need to complete all questions before you can see your results.';
    buttonText = 'Complete test';
    onButtonPressed = () {
      Navigator.of(context).pop();
      Get.to(() => const UnansweredReviewScreen());
    };
  } else if (isPassed) {
    // Passed the test (50% or more correct)
    title = 'You have successfully passed your test!';
    subtitle =
        "You're road-ready! Join now to get full benefits like driving logs, learning modules, and more.";
    buttonText = 'Close';
    onButtonPressed = () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    };
  } else {
    // Failed the test (less than 50% correct)
    title = "Looks like you didn't pass this time – don't give up!";
    subtitle =
        'You need to score at least 50% to pass. Please review the questions and try again.';
    buttonText = 'Close';
    onButtonPressed = () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    };
  }

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent tap outside to close
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Close Button (Top-Right)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),

              /// Logo
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/logo.png', // Your logo path
                height: 50,
              ),

              const SizedBox(height: 16),

              /// Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              /// Subtitle
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
