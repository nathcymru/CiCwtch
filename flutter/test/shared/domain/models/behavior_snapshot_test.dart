import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/behavior_snapshot.dart';

void main() {
  group('BehaviorSnapshot.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': 'snap-001',
        'dog_id': 'dog-001',
        'created_at': '2025-06-01T10:00:00.000Z',
        'recall_rating': 4,
        'leash_manners_rating': 3,
        'energy_level_rating': 5,
        'behavior_tags_json': '["friendly","calm"]',
        'notes': 'Good walk today',
      };

      final snapshot = BehaviorSnapshot.fromJson(json);

      expect(snapshot.id, 'snap-001');
      expect(snapshot.dogId, 'dog-001');
      expect(snapshot.createdAt, '2025-06-01T10:00:00.000Z');
      expect(snapshot.recallRating, 4);
      expect(snapshot.leashMannersRating, 3);
      expect(snapshot.energyLevelRating, 5);
      expect(snapshot.behaviorTagsJson, '["friendly","calm"]');
      expect(snapshot.notes, 'Good walk today');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'snap-002',
        'dog_id': 'dog-002',
        'created_at': '2025-06-02T12:00:00.000Z',
        'recall_rating': null,
        'leash_manners_rating': null,
        'energy_level_rating': null,
        'behavior_tags_json': null,
        'notes': null,
      };

      final snapshot = BehaviorSnapshot.fromJson(json);

      expect(snapshot.id, 'snap-002');
      expect(snapshot.dogId, 'dog-002');
      expect(snapshot.createdAt, '2025-06-02T12:00:00.000Z');
      expect(snapshot.recallRating, isNull);
      expect(snapshot.leashMannersRating, isNull);
      expect(snapshot.energyLevelRating, isNull);
      expect(snapshot.behaviorTagsJson, isNull);
      expect(snapshot.notes, isNull);
    });
  });

  group('BehaviorSnapshot.toJson', () {
    test('produces API-compatible output', () {
      const snapshot = BehaviorSnapshot(
        id: 'snap-003',
        dogId: 'dog-003',
        createdAt: '2025-06-03T08:00:00.000Z',
        recallRating: 2,
        leashMannersRating: 5,
        energyLevelRating: 3,
        behaviorTagsJson: '["reactive"]',
        notes: 'Needs work on recall',
      );

      final json = snapshot.toJson();

      expect(json['id'], 'snap-003');
      expect(json['dog_id'], 'dog-003');
      expect(json['created_at'], '2025-06-03T08:00:00.000Z');
      expect(json['recall_rating'], 2);
      expect(json['leash_manners_rating'], 5);
      expect(json['energy_level_rating'], 3);
      expect(json['behavior_tags_json'], '["reactive"]');
      expect(json['notes'], 'Needs work on recall');
    });

    test('null optional fields serialise as null', () {
      const snapshot = BehaviorSnapshot(
        id: 'snap-004',
        dogId: 'dog-004',
        createdAt: '2025-06-04T09:00:00.000Z',
      );

      final json = snapshot.toJson();

      expect(json['recall_rating'], isNull);
      expect(json['leash_manners_rating'], isNull);
      expect(json['energy_level_rating'], isNull);
      expect(json['behavior_tags_json'], isNull);
      expect(json['notes'], isNull);
    });
  });

  group('BehaviorSnapshot round-trip', () {
    test('fromJson then toJson preserves all fields', () {
      final original = <String, dynamic>{
        'id': 'snap-rt',
        'dog_id': 'dog-rt',
        'created_at': '2025-06-05T14:30:00.000Z',
        'recall_rating': 3,
        'leash_manners_rating': 4,
        'energy_level_rating': 2,
        'behavior_tags_json': '["pulls","excited"]',
        'notes': 'Improving on leash',
      };

      final snapshot = BehaviorSnapshot.fromJson(original);
      final result = snapshot.toJson();

      expect(result, equals(original));
    });
  });
}
