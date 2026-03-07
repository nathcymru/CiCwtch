class InvoiceLine {
  const InvoiceLine({
    required this.id,
    required this.invoiceHeaderId,
    this.walkId,
    required this.description,
    required this.quantity,
    required this.unitPriceMinor,
    required this.lineTotalMinor,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String invoiceHeaderId;
  final String? walkId;
  final String description;
  final double quantity;
  final int unitPriceMinor;
  final int lineTotalMinor;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  factory InvoiceLine.fromJson(Map<String, dynamic> json) {
    return InvoiceLine(
      id: json['id'] as String,
      invoiceHeaderId: json['invoice_header_id'] as String,
      walkId: json['walk_id'] as String?,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPriceMinor: json['unit_price_minor'] as int,
      lineTotalMinor: json['line_total_minor'] as int,
      sortOrder: json['sort_order'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_header_id': invoiceHeaderId,
      'walk_id': walkId,
      'description': description,
      'quantity': quantity,
      'unit_price_minor': unitPriceMinor,
      'line_total_minor': lineTotalMinor,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
