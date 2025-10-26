class SubCategoryModel {
  final int id;
  final String name;
  final String nameEn;
  final String nameKa;
  final String description;
  final String descriptionEn;
  final String descriptionKa;
  final int questionCount;
  final String iconPath;
  final String category; // B,B1 / C / D / T,S

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameKa,
    required this.description,
    required this.descriptionEn,
    required this.descriptionKa,
    required this.questionCount,
    required this.iconPath,
    required this.category,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameEn: json['nameEn'] ?? json['name'] ?? '',
      nameKa: json['nameKa'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      descriptionEn: json['descriptionEn'] ?? json['description'] ?? '',
      descriptionKa: json['descriptionKa'] ?? json['description'] ?? '',
      questionCount: json['questionCount'] ?? 0,
      iconPath: json['iconPath'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'nameKa': nameKa,
      'description': description,
      'descriptionEn': descriptionEn,
      'descriptionKa': descriptionKa,
      'questionCount': questionCount,
      'iconPath': iconPath,
      'category': category,
    };
  }
}
