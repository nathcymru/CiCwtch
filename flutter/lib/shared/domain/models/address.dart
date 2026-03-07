class Address {
  const Address({
    required this.id,
    required this.line1,
    this.line2,
    required this.city,
    this.county,
    required this.postcode,
    required this.countryCode,
    this.accessNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String line1;
  final String? line2;
  final String city;
  final String? county;
  final String postcode;
  final String countryCode;
  final String? accessNotes;
  final String createdAt;
  final String updatedAt;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      line1: json['line_1'] as String,
      line2: json['line_2'] as String?,
      city: json['city'] as String,
      county: json['county'] as String?,
      postcode: json['postcode'] as String,
      countryCode: json['country_code'] as String,
      accessNotes: json['access_notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'line_1': line1,
      'line_2': line2,
      'city': city,
      'county': county,
      'postcode': postcode,
      'country_code': countryCode,
      'access_notes': accessNotes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
