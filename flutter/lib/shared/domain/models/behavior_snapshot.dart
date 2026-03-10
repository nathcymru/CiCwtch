class BehaviorSnapshot {
  const BehaviorSnapshot({
    required this.id,
    required this.dogId,
    required this.createdAt,
    this.recallRating,
    this.leashMannersRating,
    this.energyLevelRating,
    this.behaviorTagsJson,
    this.notes,
  });

  final String id;
  final String dogId;
  final String createdAt;
  final int? recallRating;
  final int? leashMannersRating;
  final int? energyLevelRating;
  final String? behaviorTagsJson;
  final String? notes;

  factory BehaviorSnapshot.fromJson(Map<String, dynamic> json) {
    return BehaviorSnapshot(
      id: json['id'] as String,
      dogId: json['dog_id'] as String,
      createdAt: json['created_at'] as String,
      recallRating: json['recall_rating'] as int?,
      leashMannersRating: json['leash_manners_rating'] as int?,
      energyLevelRating: json['energy_level_rating'] as int?,
      behaviorTagsJson: json['behavior_tags_json'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dog_id': dogId,
      'created_at': createdAt,
      'recall_rating': recallRating,
      'leash_manners_rating': leashMannersRating,
      'energy_level_rating': energyLevelRating,
      'behavior_tags_json': behaviorTagsJson,
      'notes': notes,
    };
  }
}
