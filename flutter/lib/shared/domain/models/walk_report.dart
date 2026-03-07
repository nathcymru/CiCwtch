class WalkReport {
  const WalkReport({
    required this.id,
    required this.walkId,
    this.walkerId,
    this.summary,
    required this.weeDone,
    required this.pooDone,
    required this.foodGiven,
    required this.waterGiven,
    required this.incidentFlag,
    this.incidentNotes,
    this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String walkId;
  final String? walkerId;
  final String? summary;
  final bool weeDone;
  final bool pooDone;
  final bool foodGiven;
  final bool waterGiven;
  final bool incidentFlag;
  final String? incidentNotes;
  final int? durationMinutes;
  final String createdAt;
  final String updatedAt;

  factory WalkReport.fromJson(Map<String, dynamic> json) {
    return WalkReport(
      id: json['id'] as String,
      walkId: json['walk_id'] as String,
      walkerId: json['walker_id'] as String?,
      summary: json['summary'] as String?,
      weeDone: (json['wee_done'] as int) == 1,
      pooDone: (json['poo_done'] as int) == 1,
      foodGiven: (json['food_given'] as int) == 1,
      waterGiven: (json['water_given'] as int) == 1,
      incidentFlag: (json['incident_flag'] as int) == 1,
      incidentNotes: json['incident_notes'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walk_id': walkId,
      'walker_id': walkerId,
      'summary': summary,
      'wee_done': weeDone ? 1 : 0,
      'poo_done': pooDone ? 1 : 0,
      'food_given': foodGiven ? 1 : 0,
      'water_given': waterGiven ? 1 : 0,
      'incident_flag': incidentFlag ? 1 : 0,
      'incident_notes': incidentNotes,
      'duration_minutes': durationMinutes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
