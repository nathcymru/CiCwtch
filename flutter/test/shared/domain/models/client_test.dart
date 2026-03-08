import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/client.dart';

void main() {
  group('Client.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'full_name': 'Jane Smith',
        'preferred_name': 'Jane',
        'phone': '+44 7700 900000',
        'email': 'jane@example.com',
        'address_id': 'addr-001',
        'emergency_contact_name': 'John Smith',
        'emergency_contact_phone': '+44 7700 900001',
        'notes': 'Regular client',
        'archived_at': null,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final client = Client.fromJson(json);

      expect(client.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(client.fullName, 'Jane Smith');
      expect(client.preferredName, 'Jane');
      expect(client.phone, '+44 7700 900000');
      expect(client.email, 'jane@example.com');
      expect(client.addressId, 'addr-001');
      expect(client.emergencyContactName, 'John Smith');
      expect(client.emergencyContactPhone, '+44 7700 900001');
      expect(client.notes, 'Regular client');
      expect(client.archivedAt, isNull);
      expect(client.createdAt, '2024-01-15T10:30:00.000Z');
      expect(client.updatedAt, '2024-01-15T10:30:00.000Z');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'min-id',
        'full_name': 'Minimal Client',
        'preferred_name': null,
        'phone': null,
        'email': null,
        'address_id': null,
        'emergency_contact_name': null,
        'emergency_contact_phone': null,
        'notes': null,
        'archived_at': null,
        'created_at': '2024-06-01T00:00:00.000Z',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };

      final client = Client.fromJson(json);

      expect(client.id, 'min-id');
      expect(client.fullName, 'Minimal Client');
      expect(client.preferredName, isNull);
      expect(client.phone, isNull);
      expect(client.email, isNull);
      expect(client.addressId, isNull);
      expect(client.emergencyContactName, isNull);
      expect(client.emergencyContactPhone, isNull);
      expect(client.notes, isNull);
      expect(client.archivedAt, isNull);
    });

    test('parses archived client', () {
      final json = <String, dynamic>{
        'id': 'archived-id',
        'full_name': 'Archived Client',
        'preferred_name': null,
        'phone': null,
        'email': null,
        'address_id': null,
        'emergency_contact_name': null,
        'emergency_contact_phone': null,
        'notes': null,
        'archived_at': '2024-03-01T12:00:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-03-01T12:00:00.000Z',
      };

      final client = Client.fromJson(json);

      expect(client.archivedAt, '2024-03-01T12:00:00.000Z');
    });
  });

  group('Client.toJson', () {
    test('produces API-compatible output', () {
      const client = Client(
        id: 'test-id',
        fullName: 'Test Client',
        preferredName: 'Testy',
        phone: '+44 1234 567890',
        email: 'test@example.com',
        addressId: 'addr-1',
        emergencyContactName: 'Emergency Person',
        emergencyContactPhone: '+44 9876 543210',
        notes: 'Some notes',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-02-01T00:00:00.000Z',
      );

      final json = client.toJson();

      expect(json['id'], 'test-id');
      expect(json['full_name'], 'Test Client');
      expect(json['preferred_name'], 'Testy');
      expect(json['phone'], '+44 1234 567890');
      expect(json['email'], 'test@example.com');
      expect(json['address_id'], 'addr-1');
      expect(json['emergency_contact_name'], 'Emergency Person');
      expect(json['emergency_contact_phone'], '+44 9876 543210');
      expect(json['notes'], 'Some notes');
      expect(json['archived_at'], isNull);
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-02-01T00:00:00.000Z');
    });

    test('null optional fields serialize as null', () {
      const client = Client(
        id: 'id',
        fullName: 'Name',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      final json = client.toJson();

      expect(json['preferred_name'], isNull);
      expect(json['phone'], isNull);
      expect(json['email'], isNull);
      expect(json['address_id'], isNull);
      expect(json['emergency_contact_name'], isNull);
      expect(json['emergency_contact_phone'], isNull);
      expect(json['notes'], isNull);
      expect(json['archived_at'], isNull);
    });
  });

  group('Client round-trip', () {
    test('fromJson then toJson preserves all fields', () {
      final original = <String, dynamic>{
        'id': 'round-trip-id',
        'full_name': 'Round Trip',
        'preferred_name': 'RT',
        'phone': '+44 1111 111111',
        'email': 'rt@example.com',
        'address_id': 'addr-rt',
        'emergency_contact_name': 'EC',
        'emergency_contact_phone': '+44 2222 222222',
        'notes': 'Round trip notes',
        'archived_at': null,
        'created_at': '2024-05-01T08:00:00.000Z',
        'updated_at': '2024-05-01T09:00:00.000Z',
      };

      final client = Client.fromJson(original);
      final result = client.toJson();

      expect(result, equals(original));
    });
  });
}
