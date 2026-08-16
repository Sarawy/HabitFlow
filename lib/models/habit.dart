class Habit {
  final String id;
  final String title;
  final String category; // 'Study', 'Fitness', 'Mindset'
  bool isCompleted;
  int streak;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
    this.streak = 0,
  });

  /// Creates a copy of this habit with optional field overrides
  Habit copyWith({
    String? id,
    String? title,
    String? category,
    bool? isCompleted,
    int? streak,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
    );
  }
}

