import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';

class RecipeApiService {
  static const String baseUrl = 'https://dummyjson.com/recipes';

  static Future<List<Recipe>> fetchAllRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=50'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> list = data['recipes'] ?? [];
      return list.map((item) => Recipe.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat daftar resep (${response.statusCode})');
    }
  }

  static Future<Recipe> fetchRecipeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail resep ($id)');
    }
  }
}
