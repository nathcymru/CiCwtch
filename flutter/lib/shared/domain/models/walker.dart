class Walker {
  const Walker({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.roleTitle,
    this.startDate,
    required this.active,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String fullName;
  final String? phone;
  final String? email;
  final String? roleTitle;
  final String? startDate;
  final bool active;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory Walker.fromJson(Map<String, dynamic> json) {
    return Walker(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      roleTitle: json['role_title'] as String?,
      startDate: json['start_date'] as String?,
      active: (json['active'] as int) == 1,
      notes: json['notes'] as String?,
      archivedAt: json['archived_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'role_title': roleTitle,
      'start_date': startDate,
      'active': active ? 1 : 0,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
