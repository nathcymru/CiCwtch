class InvoiceHeader {
  const InvoiceHeader({
    required this.id,
    required this.clientId,
    required this.invoiceNumber,
    required this.status,
    this.issueDate,
    this.dueDate,
    required this.currencyCode,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String clientId;
  final String invoiceNumber;
  final String status;
  final String? issueDate;
  final String? dueDate;
  final String currencyCode;
  final String? notes;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory InvoiceHeader.fromJson(Map<String, dynamic> json) {
    return InvoiceHeader(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      status: json['status'] as String,
      issueDate: json['issue_date'] as String?,
      dueDate: json['due_date'] as String?,
      currencyCode: json['currency_code'] as String,
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
      'invoice_number': invoiceNumber,
      'status': status,
      'issue_date': issueDate,
      'due_date': dueDate,
      'currency_code': currencyCode,
      'notes': notes,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
