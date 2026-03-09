import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/shared/domain/models/dog.dart';

void main() {
  group('Dog.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'client_id': 'client-001',
        'name': 'Buddy',
        'breed': 'Labrador Retriever',
        'sex': 'male',
        'neutered': 1,
        'date_of_birth': '2020-05-15',
        'colour': 'Golden',
        'microchip_number': '900000000000001',
        'veterinary_practice': 'Main Street Vets',
        'medical_notes': 'Allergy to chicken',
        'behavioural_notes': 'Friendly with other dogs',
        'feeding_notes': 'Twice daily, grain-free',
        'archived_at': null,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(dog.clientId, 'client-001');
      expect(dog.name, 'Buddy');
      expect(dog.breed, 'Labrador Retriever');
      expect(dog.sex, 'male');
      expect(dog.neutered, isTrue);
      expect(dog.dateOfBirth, '2020-05-15');
      expect(dog.colour, 'Golden');
      expect(dog.microchipNumber, '900000000000001');
      expect(dog.veterinaryPractice, 'Main Street Vets');
      expect(dog.medicalNotes, 'Allergy to chicken');
      expect(dog.behaviouralNotes, 'Friendly with other dogs');
      expect(dog.feedingNotes, 'Twice daily, grain-free');
      expect(dog.archivedAt, isNull);
      expect(dog.createdAt, '2024-01-15T10:30:00.000Z');
      expect(dog.updatedAt, '2024-01-15T10:30:00.000Z');
    });

    test('handles null optional fields', () {
      final json = <String, dynamic>{
        'id': 'min-id',
        'client_id': 'client-002',
        'name': 'Rex',
        'breed': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'archived_at': null,
        'created_at': '2024-06-01T00:00:00.000Z',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.id, 'min-id');
      expect(dog.clientId, 'client-002');
      expect(dog.name, 'Rex');
      expect(dog.breed, isNull);
      expect(dog.sex, isNull);
      expect(dog.neutered, isFalse);
      expect(dog.dateOfBirth, isNull);
      expect(dog.colour, isNull);
      expect(dog.microchipNumber, isNull);
      expect(dog.veterinaryPractice, isNull);
      expect(dog.medicalNotes, isNull);
      expect(dog.behaviouralNotes, isNull);
      expect(dog.feedingNotes, isNull);
      expect(dog.archivedAt, isNull);
    });

    test('parses archived dog', () {
      final json = <String, dynamic>{
        'id': 'archived-id',
        'client_id': 'client-003',
        'name': 'Retired Rover',
        'breed': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'archived_at': '2024-03-01T12:00:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-03-01T12:00:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.archivedAt, '2024-03-01T12:00:00.000Z');
    });

    test('neutered 0 maps to false', () {
      final json = <String, dynamic>{
        'id': 'n0',
        'client_id': 'c',
        'name': 'A',
        'breed': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'archived_at': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      expect(Dog.fromJson(json).neutered, isFalse);
    });

    test('neutered 1 maps to true', () {
      final json = <String, dynamic>{
        'id': 'n1',
        'client_id': 'c',
        'name': 'B',
        'breed': null,
        'sex': null,
        'neutered': 1,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'archived_at': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      expect(Dog.fromJson(json).neutered, isTrue);
    });
  });

  group('Dog.toJson', () {
    test('produces API-compatible output', () {
      const dog = Dog(
        id: 'test-id',
        clientId: 'client-001',
        name: 'Buddy',
        breed: 'Labrador',
        sex: 'male',
        neutered: true,
        dateOfBirth: '2020-05-15',
        colour: 'Golden',
        microchipNumber: '900000000000001',
        veterinaryPractice: 'Main Street Vets',
        medicalNotes: 'Healthy',
        behaviouralNotes: 'Friendly',
        feedingNotes: 'Twice daily',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-02-01T00:00:00.000Z',
      );

      final json = dog.toJson();

      expect(json['id'], 'test-id');
      expect(json['client_id'], 'client-001');
      expect(json['name'], 'Buddy');
      expect(json['breed'], 'Labrador');
      expect(json['sex'], 'male');
      expect(json['neutered'], 1);
      expect(json['date_of_birth'], '2020-05-15');
      expect(json['colour'], 'Golden');
      expect(json['microchip_number'], '900000000000001');
      expect(json['veterinary_practice'], 'Main Street Vets');
      expect(json['medical_notes'], 'Healthy');
      expect(json['behavioural_notes'], 'Friendly');
      expect(json['feeding_notes'], 'Twice daily');
      expect(json['archived_at'], isNull);
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-02-01T00:00:00.000Z');
    });

    test('neutered true serialises to 1', () {
      const dog = Dog(
        id: 'id',
        clientId: 'c',
        name: 'N',
        neutered: true,
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(dog.toJson()['neutered'], 1);
    });

    test('neutered false serialises to 0', () {
      const dog = Dog(
        id: 'id',
        clientId: 'c',
        name: 'N',
        neutered: false,
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(dog.toJson()['neutered'], 0);
    });

    test('null optional fields serialise as null', () {
      const dog = Dog(
        id: 'id',
        clientId: 'c',
        name: 'N',
        neutered: false,
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      final json = dog.toJson();

      expect(json['breed'], isNull);
      expect(json['sex'], isNull);
      expect(json['date_of_birth'], isNull);
      expect(json['colour'], isNull);
      expect(json['microchip_number'], isNull);
      expect(json['veterinary_practice'], isNull);
      expect(json['medical_notes'], isNull);
      expect(json['behavioural_notes'], isNull);
      expect(json['feeding_notes'], isNull);
      expect(json['archived_at'], isNull);
    });
  });

  group('Dog round-trip', () {
    test('fromJson then toJson preserves all fields', () {
      final original = <String, dynamic>{
        'id': 'round-trip-id',
        'client_id': 'client-rt',
        'name': 'Round Trip',
        'breed': 'Poodle',
        'sex': 'female',
        'neutered': 1,
        'date_of_birth': '2019-08-20',
        'colour': 'White',
        'microchip_number': '900000000000002',
        'veterinary_practice': 'Park Vets',
        'medical_notes': 'Hip check due',
        'behavioural_notes': 'Nervous around cats',
        'feeding_notes': 'Once daily',
        'archived_at': null,
        'created_at': '2024-05-01T08:00:00.000Z',
        'updated_at': '2024-05-01T09:00:00.000Z',
      };

      final dog = Dog.fromJson(original);
      final result = dog.toJson();

      expect(result, equals(original));
    });
  });
}
