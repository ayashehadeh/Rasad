class RewardEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageEmoji;
  final int pointsCost;
  final bool isAvailable;

  const RewardEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageEmoji,
    required this.pointsCost,
    this.isAvailable = true,
  });
}

class ActivityEntity {
  final String title;
  final int points;
  final bool isEarned;
  final DateTime date;

  const ActivityEntity({
    required this.title,
    required this.points,
    required this.isEarned,
    required this.date,
  });
}
