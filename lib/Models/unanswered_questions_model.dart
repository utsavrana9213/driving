import 'package:avtoskola_varketilshi/Models/exam_question_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'unanswered_questions_model.g.dart';

@HiveType(typeId: 0)
class UnansweredQuestionsModel extends HiveObject {
  @HiveField(0)
  ExamQuestionModel? unansweredQuestions;

  UnansweredQuestionsModel({this.unansweredQuestions});
}
