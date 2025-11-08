import 'package:flutter/material.dart';
import 'package:mis_lab_1/models/exam_model.dart';
import 'package:mis_lab_1/widgets/exam_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<Exam> _exam;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExamList(order: 'asc');
  }

  @override
  Widget build(BuildContext context) {
    String badgeContent = _isLoading
        ? 'Вчитување...'
        : 'Вкупно: ${_exam.length}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(12),
                  child: ExamGrid(exam: _exam),
                ),
          Positioned(
            bottom: 30,
            right: 30,
            child: Badge(
              label: Text(
                badgeContent,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: Colors.blue.shade300,
            ),
          ),
        ],
      ),
    );
  }

  void _loadExamList({required String order}) {
    List<Exam> examList = [
      Exam(
        id: 1,
        name: 'Структурно Програмирање',
        dateTime: DateTime(2026, 1, 20, 8, 30),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3', 'Лаб 4'],
        imagePath: 'lib/icon/c-programming.png',
      ),
      Exam(
        id: 2,
        name: 'Објектно-ориентирано програмирање',
        dateTime: DateTime(2026, 2, 10, 9),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3'],
        imagePath: 'lib/icon/oop.png',
      ),
      Exam(
        id: 3,
        name: 'Бази на Податоци',
        dateTime: DateTime(2026, 2, 5, 15),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3'],
        imagePath: 'lib/icon/db.png',
      ),
      Exam(
        id: 4,
        name: 'Компјутерски Мрежи',
        dateTime: DateTime(2026, 1, 2, 14),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3', 'Лаб 4', 'Лаб 5'],
        imagePath: 'lib/icon/networks.png',
      ),
      Exam(
        id: 5,
        name: 'Алгоритми и Податочни Структури',
        dateTime: DateTime(2025, 12, 28, 19),
        locations: ['Лаб 215', 'Лаб 315'],
        imagePath: 'lib/icon/DSA.png',
      ),
      Exam(
        id: 6,
        name: 'Оперативни Системи',
        dateTime: DateTime(2025, 9, 2, 17),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3', 'Лаб 4', 'Лаб 5'],
        imagePath: 'lib/icon/os.png',
      ),
      Exam(
        id: 7,
        name: 'Веб Програмирање',
        dateTime: DateTime(2025, 9, 25, 20),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3'],
        imagePath: 'lib/icon/web-prog.png',
      ),
      Exam(
        id: 8,
        name: 'Вештачка Интелегенција',
        dateTime: DateTime(2025, 12, 5, 9),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3'],
        imagePath: 'lib/icon/ai.png',
      ),
      Exam(
        id: 9,
        name: 'Компјутерска Архитектура',
        dateTime: DateTime(2026, 1, 1, 15),
        locations: ['Лаб 1', 'Лаб 2'],
        imagePath: 'lib/icon/comp-architecture.png',
      ),
      Exam(
        id: 10,
        name: 'Тимски Проект',
        dateTime: DateTime(2025, 9, 22, 9),
        locations: ['Лаб 1', 'Лаб 2', 'Лаб 3'],
        imagePath: 'lib/icon/collaboration.png',
      ),
    ];
    if (order.toLowerCase() == 'asc') {
      examList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (order.toLowerCase() == 'desc') {
      examList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }
    setState(() {
      _exam = examList;
      _isLoading = false;
    });
  }
}
