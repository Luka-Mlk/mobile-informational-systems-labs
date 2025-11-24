import 'package:flutter/material.dart';

/// Represents a meal object as received from the filter.php endpoint.
class Meal {
  final String id;
  String name;
  String thumbnailDefault;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnailDefault,
  });

  factory Meal.fromJson(Map<String, dynamic> data) {
    String name = data['strMeal'] as String;
    String formattedName = name.isEmpty
        ? ''
        : name[0].toUpperCase() + name.substring(1);

    return Meal(
      id: data['idMeal'] as String,
      name: formattedName,
      thumbnailDefault: data['strMealThumb'] as String,
    );
  }

  /// Converts the Meal object to a JSON map.
  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strMealThumb': thumbnailDefault,
  };
}