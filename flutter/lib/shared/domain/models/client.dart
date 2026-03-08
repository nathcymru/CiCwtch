class Client {
  const Client({
    required this.id,
    required this.fullName,
    this.preferredName,
    this.phone,
    this.email,
    this.addressId,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String fullName;
  final String? preferredName;
  final String? phone;
  final String? email;
  final String? addressId;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      preferredName: json['preferred_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      addressId: json['address_id'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
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
      'preferred_name': preferredName,
      'phone': phone,
      'email': email,
      'address_id': addressId,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
