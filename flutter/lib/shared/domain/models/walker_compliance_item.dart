class WalkerComplianceItem {
  const WalkerComplianceItem({
    required this.id,
    required this.walkerId,
    required this.itemType,
    required this.status,
    this.issueDate,
    this.expiryDate,
    this.referenceNumber,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String walkerId;
  final String itemType;
  final String status;
  final String? issueDate;
  final String? expiryDate;
  final String? referenceNumber;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory WalkerComplianceItem.fromJson(Map<String, dynamic> json) {
    return WalkerComplianceItem(
      id: json['id'] as String,
      walkerId: json['walker_id'] as String,
      itemType: json['item_type'] as String,
      status: json['status'] as String,
      issueDate: json['issue_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      referenceNumber: json['reference_number'] as String?,
      notes: json['notes'] as String?,
      archivedAt: json['archived_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walker_id': walkerId,
      'item_type': itemType,
      'status': status,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'reference_number': referenceNumber,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
