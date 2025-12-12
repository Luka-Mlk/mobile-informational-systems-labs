import 'package:flutter/material.dart';
import 'package:mis_lab_2/screens/category_list_screen.dart';
import 'package:mis_lab_2/screens/meal_list_screen.dart';
import 'package:mis_lab_2/screens/meal_details_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mis_lab_2/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.initNotifications();

  notificationService.scheduleDailyRecipeReminder(
    hour: 22,
    minute: 18,
    notificationId: 0,
    title: 'Recipe of the Day!',
    body: 'Discover today\'s recipe of the day',
  );

  await notificationService.printPendingNotifications();

  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recipe app 215046",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade300)),
      initialRoute: "/",
      routes: {
        "/": (context) => const CategoryListScreen(),
        "/recipes": (context) => const MealListScreen(),
        "/details": (context) => const MealDetailsScreen()
      },
    );
  }
}
