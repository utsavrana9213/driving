class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswer;
  String? imageUrl;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.imageUrl,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsRaw = json['options'] ?? json['answers'];
    final options = (optionsRaw as List<dynamic>)
        .map((e) => e.toString().replaceFirst(RegExp(r'^\d+\n'), ''))
        .toList();

    return QuestionModel(
        question: json['question'] as String,
        options: options,
        correctAnswer: json['correctAnswer'] is int
            ? json['correctAnswer']
            : int.tryParse(json['correctAnswer'].toString()) ?? 0,
        imageUrl: json['imageUrl'] as String);
  }
}

class ExamQuestionModel {
  final int id;
  final String question;
  final List<String> options;

  ExamQuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });
}

class SubjectModel {
  final int id;
  final String title;

  SubjectModel({
    required this.id,
    required this.title,
  });
}
