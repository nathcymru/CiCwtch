class Walk {
  const Walk({
    required this.id,
    required this.clientId,
    required this.dogId,
    this.walkerId,
    required this.scheduledDate,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.status,
    required this.serviceType,
    this.pickupAddressId,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String clientId;
  final String dogId;
  final String? walkerId;
  final String scheduledDate;
  final String? scheduledStartTime;
  final String? scheduledEndTime;
  final String? actualStartTime;
  final String? actualEndTime;
  final String status;
  final String serviceType;
  final String? pickupAddressId;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory Walk.fromJson(Map<String, dynamic> json) {
    return Walk(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      dogId: json['dog_id'] as String,
      walkerId: json['walker_id'] as String?,
      scheduledDate: json['scheduled_date'] as String,
      scheduledStartTime: json['scheduled_start_time'] as String?,
      scheduledEndTime: json['scheduled_end_time'] as String?,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      status: json['status'] as String,
      serviceType: json['service_type'] as String,
      pickupAddressId: json['pickup_address_id'] as String?,
      notes: json['notes'] as String?,
      archivedAt: json['archived_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'dog_id': dogId,
      'walker_id': walkerId,
      'scheduled_date': scheduledDate,
      'scheduled_start_time': scheduledStartTime,
      'scheduled_end_time': scheduledEndTime,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'status': status,
      'service_type': serviceType,
      'pickup_address_id': pickupAddressId,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
