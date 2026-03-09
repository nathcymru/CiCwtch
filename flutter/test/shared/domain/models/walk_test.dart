import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/walk.dart';

void main() {
  group('Walk.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'client_id': 'client-001',
        'dog_id': 'dog-001',
        'walker_id': 'walker-001',
        'scheduled_date': '2024-06-15',
        'scheduled_start_time': '09:00',
        'scheduled_end_time': '10:00',
        'actual_start_time': '09:05',
        'actual_end_time': '10:02',
        'status': 'completed',
        'service_type': 'solo_walk',
        'pickup_address_id': 'addr-001',
        'notes': 'Walked in the park',
        'archived_at': null,
        'created_at': '2024-06-15T08:00:00.000Z',
        'updated_at': '2024-06-15T10:05:00.000Z',
      };

      final walk = Walk.fromJson(json);

      expect(walk.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(walk.clientId, 'client-001');
      expect(walk.dogId, 'dog-001');
      expect(walk.walkerId, 'walker-001');
      expect(walk.scheduledDate, '2024-06-15');
      expect(walk.scheduledStartTime, '09:00');
      expect(walk.scheduledEndTime, '10:00');
      expect(walk.actualStartTime, '09:05');
      expect(walk.actualEndTime, '10:02');
      expect(walk.status, 'completed');
      expect(walk.serviceType, 'solo_walk');
      expect(walk.pickupAddressId, 'addr-001');
      expect(walk.notes, 'Walked in the park');
      expect(walk.archivedAt, isNull);
      expect(walk.createdAt, '2024-06-15T08:00:00.000Z');
      expect(walk.updatedAt, '2024-06-15T10:05:00.000Z');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'min-id',
        'client_id': 'client-002',
        'dog_id': 'dog-002',
        'walker_id': null,
        'scheduled_date': '2024-07-01',
        'scheduled_start_time': null,
        'scheduled_end_time': null,
        'actual_start_time': null,
        'actual_end_time': null,
        'status': 'planned',
        'service_type': 'group_walk',
        'pickup_address_id': null,
        'notes': null,
        'archived_at': null,
        'created_at': '2024-06-30T00:00:00.000Z',
        'updated_at': '2024-06-30T00:00:00.000Z',
      };

      final walk = Walk.fromJson(json);

      expect(walk.id, 'min-id');
      expect(walk.clientId, 'client-002');
      expect(walk.dogId, 'dog-002');
      expect(walk.walkerId, isNull);
      expect(walk.scheduledDate, '2024-07-01');
      expect(walk.scheduledStartTime, isNull);
      expect(walk.scheduledEndTime, isNull);
      expect(walk.actualStartTime, isNull);
      expect(walk.actualEndTime, isNull);
      expect(walk.status, 'planned');
      expect(walk.serviceType, 'group_walk');
      expect(walk.pickupAddressId, isNull);
      expect(walk.notes, isNull);
      expect(walk.archivedAt, isNull);
    });

    test('parses archived walk', () {
      final json = <String, dynamic>{
        'id': 'archived-id',
        'client_id': 'client-003',
        'dog_id': 'dog-003',
        'walker_id': null,
        'scheduled_date': '2024-01-10',
        'scheduled_start_time': null,
        'scheduled_end_time': null,
        'actual_start_time': null,
        'actual_end_time': null,
        'status': 'cancelled',
        'service_type': 'home_visit',
        'pickup_address_id': null,
        'notes': null,
        'archived_at': '2024-03-01T12:00:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-03-01T12:00:00.000Z',
      };

      final walk = Walk.fromJson(json);

      expect(walk.archivedAt, '2024-03-01T12:00:00.000Z');
    });

    test('parses all valid status values', () {
      for (final status in ['planned', 'in_progress', 'completed', 'cancelled']) {
        final json = <String, dynamic>{
          'id': 'status-$status',
          'client_id': 'c',
          'dog_id': 'd',
          'walker_id': null,
          'scheduled_date': '2024-01-01',
          'scheduled_start_time': null,
          'scheduled_end_time': null,
          'actual_start_time': null,
          'actual_end_time': null,
          'status': status,
          'service_type': 'solo_walk',
          'pickup_address_id': null,
          'notes': null,
          'archived_at': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        };

        expect(Walk.fromJson(json).status, status);
      }
    });

    test('parses all valid service type values', () {
      for (final type in ['group_walk', 'solo_walk', 'home_visit', 'drop_in']) {
        final json = <String, dynamic>{
          'id': 'type-$type',
          'client_id': 'c',
          'dog_id': 'd',
          'walker_id': null,
          'scheduled_date': '2024-01-01',
          'scheduled_start_time': null,
          'scheduled_end_time': null,
          'actual_start_time': null,
          'actual_end_time': null,
          'status': 'planned',
          'service_type': type,
          'pickup_address_id': null,
          'notes': null,
          'archived_at': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        };

        expect(Walk.fromJson(json).serviceType, type);
      }
    });
  });

  group('Walk.toJson', () {
    test('produces API-compatible output', () {
      const walk = Walk(
        id: 'test-id',
        clientId: 'client-001',
        dogId: 'dog-001',
        walkerId: 'walker-001',
        scheduledDate: '2024-06-15',
        scheduledStartTime: '09:00',
        scheduledEndTime: '10:00',
        actualStartTime: '09:05',
        actualEndTime: '10:02',
        status: 'completed',
        serviceType: 'solo_walk',
        pickupAddressId: 'addr-001',
        notes: 'Walked in the park',
        createdAt: '2024-06-15T08:00:00.000Z',
        updatedAt: '2024-06-15T10:05:00.000Z',
      );

      final json = walk.toJson();

      expect(json['id'], 'test-id');
      expect(json['client_id'], 'client-001');
      expect(json['dog_id'], 'dog-001');
      expect(json['walker_id'], 'walker-001');
      expect(json['scheduled_date'], '2024-06-15');
      expect(json['scheduled_start_time'], '09:00');
      expect(json['scheduled_end_time'], '10:00');
      expect(json['actual_start_time'], '09:05');
      expect(json['actual_end_time'], '10:02');
      expect(json['status'], 'completed');
      expect(json['service_type'], 'solo_walk');
      expect(json['pickup_address_id'], 'addr-001');
      expect(json['notes'], 'Walked in the park');
      expect(json['archived_at'], isNull);
      expect(json['created_at'], '2024-06-15T08:00:00.000Z');
      expect(json['updated_at'], '2024-06-15T10:05:00.000Z');
    });

    test('null optional fields serialise as null', () {
      const walk = Walk(
        id: 'id',
        clientId: 'c',
        dogId: 'd',
        scheduledDate: '2024-01-01',
        status: 'planned',
        serviceType: 'solo_walk',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      final json = walk.toJson();

      expect(json['walker_id'], isNull);
      expect(json['scheduled_start_time'], isNull);
      expect(json['scheduled_end_time'], isNull);
      expect(json['actual_start_time'], isNull);
      expect(json['actual_end_time'], isNull);
      expect(json['pickup_address_id'], isNull);
      expect(json['notes'], isNull);
      expect(json['archived_at'], isNull);
    });
  });

  group('Walk round-trip', () {
    test('fromJson then toJson preserves all fields', () {
      final original = <String, dynamic>{
        'id': 'round-trip-id',
        'client_id': 'client-rt',
        'dog_id': 'dog-rt',
        'walker_id': 'walker-rt',
        'scheduled_date': '2024-08-20',
        'scheduled_start_time': '14:00',
        'scheduled_end_time': '15:30',
        'actual_start_time': '14:05',
        'actual_end_time': '15:25',
        'status': 'completed',
        'service_type': 'group_walk',
        'pickup_address_id': 'addr-rt',
        'notes': 'Round trip walk notes',
        'archived_at': null,
        'created_at': '2024-08-20T13:00:00.000Z',
        'updated_at': '2024-08-20T15:30:00.000Z',
      };

      final walk = Walk.fromJson(original);
      final result = walk.toJson();

      expect(result, equals(original));
    });
  });
}
