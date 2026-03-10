import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/vaccination.dart';

void main() {
  group('Vaccination.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': 'vac-001',
        'dog_id': 'dog-001',
        'vaccination_name': 'Rabies',
        'date_administered': '2025-06-01',
        'expiration_date': '2026-06-01',
        'document_object_key': 'docs/rabies-cert.pdf',
        'created_at': '2025-06-01T10:00:00.000Z',
        'updated_at': '2025-06-01T10:00:00.000Z',
      };

      final vaccination = Vaccination.fromJson(json);

      expect(vaccination.id, 'vac-001');
      expect(vaccination.dogId, 'dog-001');
      expect(vaccination.vaccinationName, 'Rabies');
      expect(vaccination.dateAdministered, '2025-06-01');
      expect(vaccination.expirationDate, '2026-06-01');
      expect(vaccination.documentObjectKey, 'docs/rabies-cert.pdf');
      expect(vaccination.createdAt, '2025-06-01T10:00:00.000Z');
      expect(vaccination.updatedAt, '2025-06-01T10:00:00.000Z');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'vac-002',
        'dog_id': 'dog-002',
        'vaccination_name': 'Distemper',
        'date_administered': '2025-03-15',
        'expiration_date': null,
        'document_object_key': null,
        'created_at': '2025-03-15T08:00:00.000Z',
        'updated_at': '2025-03-15T08:00:00.000Z',
      };

      final vaccination = Vaccination.fromJson(json);

      expect(vaccination.id, 'vac-002');
      expect(vaccination.dogId, 'dog-002');
      expect(vaccination.vaccinationName, 'Distemper');
      expect(vaccination.dateAdministered, '2025-03-15');
      expect(vaccination.expirationDate, isNull);
      expect(vaccination.documentObjectKey, isNull);
    });
  });

  group('Vaccination.toJson', () {
    test('serialises all fields', () {
      const vaccination = Vaccination(
        id: 'vac-001',
        dogId: 'dog-001',
        vaccinationName: 'Rabies',
        dateAdministered: '2025-06-01',
        expirationDate: '2026-06-01',
        documentObjectKey: 'docs/rabies-cert.pdf',
        createdAt: '2025-06-01T10:00:00.000Z',
        updatedAt: '2025-06-01T10:00:00.000Z',
      );

      final json = vaccination.toJson();

      expect(json['id'], 'vac-001');
      expect(json['dog_id'], 'dog-001');
      expect(json['vaccination_name'], 'Rabies');
      expect(json['date_administered'], '2025-06-01');
      expect(json['expiration_date'], '2026-06-01');
      expect(json['document_object_key'], 'docs/rabies-cert.pdf');
      expect(json['created_at'], '2025-06-01T10:00:00.000Z');
      expect(json['updated_at'], '2025-06-01T10:00:00.000Z');
    });

    test('serialises null optional fields', () {
      const vaccination = Vaccination(
        id: 'vac-002',
        dogId: 'dog-002',
        vaccinationName: 'Distemper',
        dateAdministered: '2025-03-15',
        createdAt: '2025-03-15T08:00:00.000Z',
        updatedAt: '2025-03-15T08:00:00.000Z',
      );

      final json = vaccination.toJson();

      expect(json['expiration_date'], isNull);
      expect(json['document_object_key'], isNull);
    });
  });
}
