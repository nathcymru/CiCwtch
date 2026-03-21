class AuthUser {
  const AuthUser({
    required this.id,
    required this.organisationId,
    required this.email,
    required this.fullName,
    required this.role,
  });

  final String id;
  final String organisationId;
  final String email;
  final String fullName;
  final String role;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      organisationId: json['organisation_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
    );
  }
}
