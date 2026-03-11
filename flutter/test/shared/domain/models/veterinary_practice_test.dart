import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/veterinary_practice.dart';

void main() {
  group('VeterinaryPractice.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': 'vet-001',
        'name': 'Rhiwbina Vets',
        'phone': '029 2061 1234',
        'email': 'info@rhiwbinavets.example.com',
        'address': '12 Heol y Deri, Rhiwbina, Cardiff CF14 6UH',
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final vp = VeterinaryPractice.fromJson(json);

      expect(vp.id, 'vet-001');
      expect(vp.name, 'Rhiwbina Vets');
      expect(vp.phone, '029 2061 1234');
      expect(vp.email, 'info@rhiwbinavets.example.com');
      expect(vp.address, '12 Heol y Deri, Rhiwbina, Cardiff CF14 6UH');
      expect(vp.createdAt, '2024-01-15T10:30:00.000Z');
      expect(vp.updatedAt, '2024-01-15T10:30:00.000Z');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'vet-min',
        'name': 'Minimal Vet',
        'phone': null,
        'email': null,
        'address': null,
        'created_at': '2024-06-01T00:00:00.000Z',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };

      final vp = VeterinaryPractice.fromJson(json);

      expect(vp.id, 'vet-min');
      expect(vp.name, 'Minimal Vet');
      expect(vp.phone, isNull);
      expect(vp.email, isNull);
      expect(vp.address, isNull);
    });
  });

  group('VeterinaryPractice.toJson', () {
    test('produces API-compatible output', () {
      const vp = VeterinaryPractice(
        id: 'vet-001',
        name: 'Park Vets',
        phone: '01onal',
        email: 'park@example.com',
        address: '1 Park Lane',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-02-01T00:00:00.000Z',
      );

      final json = vp.toJson();

      expect(json['id'], 'vet-001');
      expect(json['name'], 'Park Vets');
      expect(json['phone'], '01onal');
      expect(json['email'], 'park@example.com');
      expect(json['address'], '1 Park Lane');
    });
  });

  group('VeterinaryPractice round-trip', () {
    test('fromJson then toJson preserves all fields', () {
      final original = <String, dynamic>{
        'id': 'vet-rt',
        'name': 'Round Trip Vets',
        'phone': '01onal 123',
        'email': 'rt@example.com',
        'address': '5 Round Trip Road',
        'created_at': '2024-05-01T08:00:00.000Z',
        'updated_at': '2024-05-01T09:00:00.000Z',
      };

      final vp = VeterinaryPractice.fromJson(original);
      final result = vp.toJson();

      expect(result, equals(original));
    });
  });
}
