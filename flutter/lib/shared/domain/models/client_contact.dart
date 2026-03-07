class ClientContact {
  const ClientContact({
    required this.id,
    required this.clientId,
    required this.fullName,
    this.relationshipToClient,
    this.phone,
    this.email,
    required this.isPrimary,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String clientId;
  final String fullName;
  final String? relationshipToClient;
  final String? phone;
  final String? email;
  final bool isPrimary;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory ClientContact.fromJson(Map<String, dynamic> json) {
    return ClientContact(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      fullName: json['full_name'] as String,
      relationshipToClient: json['relationship_to_client'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isPrimary: (json['is_primary'] as int) == 1,
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
      'full_name': fullName,
      'relationship_to_client': relationshipToClient,
      'phone': phone,
      'email': email,
      'is_primary': isPrimary ? 1 : 0,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
