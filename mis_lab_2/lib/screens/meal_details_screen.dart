import 'package:flutter/material.dart';
import 'package:mis_lab_2/models/meal_details_model.dart';
import 'package:mis_lab_2/services/mealdb_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Не може да се отвори URL: $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Грешка при отворање на линкот: ${e.toString()}')),
      );
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context)!.settings.arguments as String;

    final _mealDBService = MealDBService();
    final Future<MealDetails?> _detailsFuture = _mealDBService.fetchMealDetails(mealId);

    return Scaffold(
      body: FutureBuilder<MealDetails?>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Грешка при вчитување на деталите: ${snapshot.error.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final details = snapshot.data;

          if (details == null) {
            return const Center(
              child: Text(
                'Детали за рецептот не се пронајдени.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    details.name,
                    style: const TextStyle(shadows: [Shadow(blurRadius: 5.0, color: Colors.black)]),
                  ),
                  centerTitle: true,
                  background: Image.network(
                    details.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.brown.shade100, child: const Center(child: Icon(Icons.fastfood, size: 80, color: Colors.brown))),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(Icons.category, 'Категорија', details.category),
                          _buildInfoChip(Icons.location_on, 'Област', details.area),
                        ],
                      ),
                    ),

                    _buildSectionTitle(context, 'Состојки', Icons.shopping_basket),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: details.ingredients.map((ing) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text('• ${ing.measure} ${ing.ingredient}', style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ),
                    ),

                    _buildSectionTitle(context, 'Инструкции', Icons.menu_book),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        details.instructions,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    if (details.youtubeLink != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUrl(context, details.youtubeLink!),
                          icon: const Icon(Icons.smart_display, color: Colors.red),
                          label: const Text('Погледни видео рецепт'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
