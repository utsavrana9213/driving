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
  @HiveField(10)
  final String? questionEn;
  @HiveField(11)
  final List<String>? optionsEn;

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
    this.questionEn,
    this.optionsEn,
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
        questionEn: json['questionEn'],
        optionsEn: json['answersEn'] != null 
            ? (json['answersEn'] as List)
                .map((e) => e.toString().replaceFirst(RegExp(r'^\d+\n'), ''))
                .toList()
            : null,
        isExpanded: false,
        selectedIndex: null);
  }

  // Helper methods to get localized content
  String getLocalizedQuestion(String languageCode) {
    switch (languageCode) {
      case 'en':
        return (questionEn != null && questionEn!.isNotEmpty) ? questionEn! : question;
      case 'ka':
      default:
        return question;
      // Add more languages here easily:
      // case 'ru':
      //   return (questionRu != null && questionRu!.isNotEmpty) ? questionRu! : question;
    }
  }

  List<String> getLocalizedOptions(String languageCode) {
    switch (languageCode) {
      case 'en':
        return (optionsEn != null && optionsEn!.isNotEmpty) ? optionsEn! : options;
      case 'ka':
      default:
        return options;
      // Add more languages here easily:
      // case 'ru':
      //   return (optionsRu != null && optionsRu!.isNotEmpty) ? optionsRu! : options;
    }
  }
  
  // Backward compatibility methods
  String getLocalizedQuestionLegacy(bool isEnglish) {
    return getLocalizedQuestion(isEnglish ? 'en' : 'ka');
  }

  List<String> getLocalizedOptionsLegacy(bool isEnglish) {
    return getLocalizedOptions(isEnglish ? 'en' : 'ka');
  }
}
