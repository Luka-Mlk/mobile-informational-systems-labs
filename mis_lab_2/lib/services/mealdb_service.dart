import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mis_lab_2/models/category_model.dart';
import 'package:mis_lab_2/models/meal_model.dart';
import 'package:mis_lab_2/models/meal_details_model.dart';

class MealDBService {
  static const String _baseUrl = 'www.themealdb.com';
  static const String _devKey = '1';

  /// Get all meal categories
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/$_devKey/categories.php');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categoriesJson = data['categories'] ?? [];

        return categoriesJson
            .map((json) => Category.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Get meals by category
  Future<List<Meal>> fetchMealsByCategory(String categoryName) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/$_devKey/filter.php', {'c': categoryName});

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List mealsJson = data['meals'] ?? [];

        return mealsJson
            .map((json) => Meal.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load meals for category $categoryName. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meals by category: $e');
    }
  }

  /// Get meal details by id
  Future<MealDetails?> fetchMealDetails(String mealId) async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/$_devKey/lookup.php', {'i': mealId});

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List mealsJson = data['meals'] ?? [];

        if (mealsJson.isNotEmpty) {
          return MealDetails.fromJson(mealsJson.first);
        }
        return null; // Meal not found
      } else {
        throw Exception('Failed to load meal details for ID $mealId. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meal details: $e');
    }
  }

  /// Get random meal of the day
  Future<MealDetails?> fetchRandomMeal() async {
    final uri = Uri.https(_baseUrl, '/api/json/v1/$_devKey/random.php');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List mealsJson = data['meals'] ?? [];

        if (mealsJson.isNotEmpty) {
          return MealDetails.fromJson(mealsJson.first);
        }
        return null;
      } else {
        throw Exception('Failed to load random meal. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching random meal: $e');
    }
  }
}