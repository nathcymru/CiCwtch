class AuditLogEntry {
  const AuditLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.actorType,
    this.actorId,
    this.changeSummary,
    required this.createdAt,
  });

  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String? actorType;
  final String? actorId;
  final String? changeSummary;
  final String createdAt;

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      action: json['action'] as String,
      actorType: json['actor_type'] as String?,
      actorId: json['actor_id'] as String?,
      changeSummary: json['change_summary'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'action': action,
      'actor_type': actorType,
      'actor_id': actorId,
      'change_summary': changeSummary,
      'created_at': createdAt,
    };
  }
}
