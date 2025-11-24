class Category {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final rawId = json['idCategory'];
    String safeId;
    if (rawId is int) {
      safeId = rawId.toString();
    } else {
      safeId = rawId as String;
    }

    return Category(
      id: safeId,
      name: json['strCategory'] as String,
      thumbnail: json['strCategoryThumb'] as String,
      description: json['strCategoryDescription'] as String,
    );
  }
}