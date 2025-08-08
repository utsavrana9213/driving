import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/unanswered_questions_services.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final UnansweredQuestionsServices _unansweredService = Get.find<UnansweredQuestionsServices>();

  void toggleExpand(int index) {
    final unansweredQuestions = _unansweredService.unansweredQuestions;
    if (index < unansweredQuestions.length) {
      final question = unansweredQuestions[index].unansweredQuestions;
      if (question != null) {
        question.isExpanded = !(question.isExpanded ?? false);
        _unansweredService.unansweredQuestions.refresh();
      }
    }
  }
}
