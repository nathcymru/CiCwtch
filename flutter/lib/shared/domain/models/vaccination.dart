class Vaccination {
  const Vaccination({
    required this.id,
    required this.dogId,
    required this.vaccinationName,
    required this.dateAdministered,
    this.expirationDate,
    this.documentObjectKey,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String dogId;
  final String vaccinationName;
  final String dateAdministered;
  final String? expirationDate;
  final String? documentObjectKey;
  final String createdAt;
  final String updatedAt;

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'] as String,
      dogId: json['dog_id'] as String,
      vaccinationName: json['vaccination_name'] as String,
      dateAdministered: json['date_administered'] as String,
      expirationDate: json['expiration_date'] as String?,
      documentObjectKey: json['document_object_key'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dog_id': dogId,
      'vaccination_name': vaccinationName,
      'date_administered': dateAdministered,
      'expiration_date': expirationDate,
      'document_object_key': documentObjectKey,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
