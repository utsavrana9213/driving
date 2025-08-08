class ReviewQuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final int? correctIndex;
  final int? selectedIndex;
  final String? imageUrl;
  bool isExpanded;

  ReviewQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    this.correctIndex,
    this.selectedIndex,
    this.imageUrl,
    this.isExpanded = false,
  });
}
