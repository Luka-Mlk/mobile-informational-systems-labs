import 'package:flutter/material.dart';
import 'package:mis_lab_1/widgets/details_data.dart';
import 'package:mis_lab_1/widgets/details_image.dart';

import 'package:mis_lab_1/models/exam_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exam = ModalRoute.of(context)!.settings.arguments as Exam;
    Color backgroundColor = Colors.blue.shade300;
    if (exam.dateTime.isBefore(DateTime.now())) {
      backgroundColor = Colors.red.shade300;
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(exam.name, softWrap: true),
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            DetailImage(image: exam.imagePath),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            DetailData(exam: exam),
          ],
        ),
      ),
    );
  }
}
