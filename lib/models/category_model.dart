import '../core/utils/category_translator.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['serviceCategoryId'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }

  String get displayName {
    return categoryES[name] ?? name;
  }
}