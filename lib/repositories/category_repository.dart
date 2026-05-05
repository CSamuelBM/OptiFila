import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryRepository {
  static const _baseUrl =
      'https://backi251-optifila-backend.hf.space/api/v1';

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/category'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener categorías');
    }

    final decoded = jsonDecode(response.body);
    final List list = decoded['data'];

    return list
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }
}