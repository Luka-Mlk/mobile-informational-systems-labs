import 'dart:ui';

class Exam {
  int id;
  String name;
  DateTime dateTime;
  List<String> locations;
  String imagePath;

  Exam({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.locations,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateTime': dateTime,
    'locations': locations,
    'image': imagePath,
  };
}
