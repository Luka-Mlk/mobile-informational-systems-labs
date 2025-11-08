import 'package:flutter/material.dart';
import 'package:mis_lab_1/models/exam_model.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.blue.shade300;
    if (exam.dateTime.isBefore(DateTime.now())) {
      borderColor = Colors.red.shade300;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/details", arguments: exam);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(exam.imagePath, height: 50),
              const SizedBox(height: 8),
              // Divider(),
              Text(exam.name, style: TextStyle(fontSize: 20)),
              // Text(exam.dateTime.toString(), style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
