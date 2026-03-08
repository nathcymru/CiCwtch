class DogNote {
  const DogNote({
    required this.id,
    required this.dogId,
    this.noteType,
    required this.noteBody,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String dogId;
  final String? noteType;
  final String noteBody;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory DogNote.fromJson(Map<String, dynamic> json) {
    return DogNote(
      id: json['id'] as String,
      dogId: json['dog_id'] as String,
      noteType: json['note_type'] as String?,
      noteBody: json['note_body'] as String,
      archivedAt: json['archived_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dog_id': dogId,
      'note_type': noteType,
      'note_body': noteBody,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
