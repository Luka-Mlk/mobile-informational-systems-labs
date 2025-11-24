import 'package:flutter/material.dart';
import 'package:mis_lab_2/models/category_model.dart';
import 'package:mis_lab_2/models/meal_model.dart';
import 'package:mis_lab_2/services/mealdb_service.dart';
import 'package:mis_lab_2/widgets/meal_card_widget.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealDBService _mealDBService = MealDBService();

  List<Meal> _allMeals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();

  late Category _category;
  bool _isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataInitialized) {
      _category = ModalRoute.of(context)!.settings.arguments as Category;
      _fetchMeals();
      _searchController.addListener(_filterMeals);
      _isDataInitialized = true;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMeals);
    _searchController.dispose();
    super.dispose();
  }

  /// Get meals
  Future<void> _fetchMeals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final meals = await _mealDBService.fetchMealsByCategory(_category.name);
      setState(() {
        _allMeals = meals;
        _filteredMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching recipes: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  /// Get meal by category and search
  void _filterMeals() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredMeals = _allMeals;
      } else {
        _filteredMeals = _allMeals.where((meal) {
          // Meal name contains query
          return meal.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _navigateToDetailsScreen(String mealId) {
    // Navigate to the actual details screen, passing the meal ID.
    Navigator.of(context).pushNamed(
      '/details',
      arguments: mealId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search recipes',
                hintText: 'Enter name of recipe...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
            ),
          ),

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
                      onPressed: _fetchMeals, // Retry logic
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            )
                : _filteredMeals.isEmpty
                ? Center(
              child: Text(
                _searchController.text.isEmpty
                    ? 'No recipes from this category'
                    : 'No recipes that fit description: "${_searchController.text}".',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: _filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = _filteredMeals[index];
                return MealCardWidget(
                  meal: meal,
                  onTap: () => _navigateToDetailsScreen(meal.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
