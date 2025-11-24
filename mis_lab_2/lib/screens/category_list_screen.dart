import 'package:flutter/material.dart';
import 'package:mis_lab_2/models/category_model.dart';
import 'package:mis_lab_2/services/mealdb_service.dart';
import 'package:mis_lab_2/widgets/category_card_widget.dart';
import 'package:mis_lab_2/models/meal_details_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final MealDBService _mealDBService = MealDBService();

  // State
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;
  String? _error;

  // Controller for search
  final TextEditingController _searchController = TextEditingController();

  // Recipe of the Day
  late Future<MealDetails?> _randomMealFuture;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    // Initialize the random meal future
    _randomMealFuture = _mealDBService.fetchRandomMeal();
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCategories);
    _searchController.dispose();
    super.dispose();
  }

  /// All categories from API.
  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final categories = await _mealDBService.fetchCategories();
      setState(() {
        _allCategories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching categories: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  /// Search categories
  void _filterCategories() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories.where((category) {
          // Check if category name or description contains the query
          return category.name.toLowerCase().contains(query) ||
              category.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  /// Go to meals
  void _navigateToMealsScreen(Category category) {
    Navigator.of(context).pushNamed(
      '/recipes',
      arguments: category,
    );
  }

  /// Go to meal
  void _navigateToDetailsScreen(String mealId) {
    Navigator.of(context).pushNamed(
      '/details',
      arguments: mealId,
    );
  }

  /// FutureBuilder for recipe of the day
  Widget _buildRecipeOfTheDay() {
    return FutureBuilder<MealDetails?>(
      future: _randomMealFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(child: LinearProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          // If error or no data, quietly skip the widget
          return const SizedBox.shrink();
        }

        final meal = snapshot.data!;
        return GestureDetector(
          onTap: () => _navigateToDetailsScreen(meal.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0, top: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal Thumbnail
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    meal.thumbnail,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.brown.shade100,
                      child: const Icon(Icons.fastfood, color: Colors.brown),
                    ),
                  ),
                ),

                // Text Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recipe of the day',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meal.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Arrow Icon
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe categories'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildRecipeOfTheDay(),

          // Search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search categories',
                hintText: 'Enter name or description...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
            ),
          ),

          // Content Area (Loading, Error, or List)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _fetchCategories,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            )
                : _filteredCategories.isEmpty
                ? Center(
              child: Text(
                _searchController.text.isEmpty
                    ? 'No categories found.'
                    : 'No categories fit the criteria "${_searchController.text}".',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                final category = _filteredCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CategoryCardWidget(
                    category: category,
                    onTap: () => _navigateToMealsScreen(category),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
