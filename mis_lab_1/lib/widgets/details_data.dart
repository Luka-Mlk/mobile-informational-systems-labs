import 'package:flutter/material.dart';
import 'package:mis_lab_1/models/exam_model.dart';

class DetailData extends StatelessWidget {
  final Exam exam;

  const DetailData({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    String trimmedDateTime = exam.dateTime.toString().substring(0, 16);
    Duration timeRemaining = exam.dateTime.difference(DateTime.now());
    int days = timeRemaining.inDays;
    int remainingHours = timeRemaining.inHours % 24;
    String timeRemainingFormatted = "$days дена, $remainingHours часа";
    return Container(
      height: 450,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _infoRow('Име', exam.name),
          _infoRow('Датум', trimmedDateTime),
          _infoRow('Лаборатории', exam.locations.toString()),
          _infoRow('За', timeRemainingFormatted)
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 18)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
