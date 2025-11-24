import 'package:flutter/material.dart';
import 'package:mis_lab_2/screens/category_list_screen.dart';
import 'package:mis_lab_2/screens/meal_list_screen.dart';
import 'package:mis_lab_2/screens/meal_details_screen.dart';

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Апликација за рецепти 215046",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade300)
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const CategoryListScreen(),
        "/recipes": (context) => const MealListScreen(),
        "/details": (context) => const MealDetailsScreen()
      },
    );
  }
}
