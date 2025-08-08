import 'package:hive_flutter/hive_flutter.dart';
part 'exam_question_model.g.dart';

@HiveType(typeId: 1)
class ExamQuestionModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String question;
  @HiveField(2)
  final List<String> options;
  @HiveField(3)
  final int correctAnswer;
  @HiveField(4)
  final String? previewVideo;
  @HiveField(5)
  final String? correctVideo;
  @HiveField(6)
  final String? wrongVideo;
  @HiveField(7)
  bool? isExpanded;
  @HiveField(8)
  int? selectedIndex;
  @HiveField(9)
  String? imageUrl;

  ExamQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.previewVideo,
    this.correctVideo,
    this.wrongVideo,
    this.isExpanded = false,
    this.selectedIndex,
    this.imageUrl,
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamQuestionModel(
        id: json['id'],
        question: json['question'],
        options: (json['answers'] as List)
            .map((e) => e.toString().replaceFirst(RegExp(r'^\d+\n'), ''))
            .toList(),
        correctAnswer: json['correctAnswer'],
        previewVideo: json['previewVideo'],
        correctVideo: json['correctVideo'],
        wrongVideo: json['wrongVideo'],
        imageUrl: json['imageUrl'],
        isExpanded: false,
        selectedIndex: null);
  }
}
