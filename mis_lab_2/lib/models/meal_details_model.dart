class IngredientMeasure {
  final String ingredient;
  final String measure;

  IngredientMeasure(this.ingredient, this.measure);
}

class MealDetails {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? youtubeLink;
  final List<IngredientMeasure> ingredients;

  MealDetails({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeLink,
    required this.ingredients,
  });

  factory MealDetails.fromJson(Map<String, dynamic> data) {
    // Parse Ingredients and Measures
    final List<IngredientMeasure> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredientKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';

      // Helper function to extract and clean the string value
      String? safeString(String key) {
        final value = data[key];
        if (value is String && value.isNotEmpty && value.trim() != '') {
          return value.trim();
        }
        return null;
      }

      final ingredient = safeString(ingredientKey);
      final measure = safeString(measureKey);

      if (ingredient != null && measure != null) {
        final formattedIngredient = ingredient[0].toUpperCase() + ingredient.substring(1);
        ingredientsList.add(IngredientMeasure(
          formattedIngredient,
          measure,
        ));
      }
    }

    // Main Details
    final String mealName = data['strMeal'] as String;
    final String formattedName = mealName.isEmpty
        ? ''
        : mealName[0].toUpperCase() + mealName.substring(1);

    // Possibly empty string fields
    String safeInstruction = data['strInstructions'] as String? ?? 'No instructions provided.';

    return MealDetails(
      id: data['idMeal'] as String,
      name: formattedName,
      category: data['strCategory'] as String? ?? 'Unknown',
      area: data['strArea'] as String? ?? 'Unknown',
      instructions: safeInstruction,
      thumbnail: data['strMealThumb'] as String,
      youtubeLink: data['strYoutube'] is String && (data['strYoutube'] as String).isNotEmpty
          ? data['strYoutube'] as String
          : null,
      ingredients: ingredientsList,
    );
  }
}