import 'package:optifila/models/category_model.dart';

class ServiceModel {
  final String serviceId;
  final String serviceName;
  final CategoryModel category;
  final String email;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.email,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      category: CategoryModel.fromJson(json['serviceCategory']),
      email: json['email'] as String,
    );
  }
}