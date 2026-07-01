import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/network/rest/api_client.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepository(this._apiClient);

  Future<List<CategoryModel>> getCategories() async {

    final decoded = await _apiClient.get(
      '/category',
    );
    final List list = decoded['data'];

    return list
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }
}