class Recipe {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final int caloriesPerServing;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.caloriesPerServing,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tanpa Judul',
      cuisine: json['cuisine'] ?? 'Umum',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      difficulty: json['difficulty'] ?? 'Medium',
      caloriesPerServing: json['caloriesPerServing'] ?? 0,
      image: json['image'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      mealType: List<String>.from(json['mealType'] ?? []),
    );
  }
}
