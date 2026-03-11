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
        'breed_id': 'breed-labrador-retriever',
        'breed_name': 'Labrador Retriever',
        'sex': 'male',
        'neutered': 1,
        'date_of_birth': '2020-05-15',
        'colour': 'Golden',
        'microchip_number': '900000000000001',
        'veterinary_practice': 'Main Street Vets',
        'medical_notes': 'Allergy to chicken',
        'behavioural_notes': 'Friendly with other dogs',
        'feeding_notes': 'Twice daily, grain-free',
        'avatar_object_key': 'dogs/550e8400-e29b-41d4-a716-446655440000/avatar/original.jpg',
        'profile_photo_object_key': 'dogs/550e8400-e29b-41d4-a716-446655440000/profile/original.jpg',
        'nose_print_object_key': 'dogs/550e8400-e29b-41d4-a716-446655440000/nose-print/original.jpg',
        'allergies': 1,
        'allergies_notes': 'Chicken protein',
        'medication': 1,
        'medication_notes': 'Glucosamine daily',
        'vet_practice_id': 'vet-001',
        'vet_practice_name': 'Main Street Vets',
        'energy_level': 'medium',
        'leash_manners': 'good',
        'recall_rating': 'excellent',
        'aggressive': 0,
        'muzzle_required': 0,
        'special_commands': 'Hand signal for sit',
        'walking_gear_object_key': 'dogs/550e8400-e29b-41d4-a716-446655440000/gear/original.jpg',
        'gear_location': 'Hooks by back door',
        'archived_at': null,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(dog.clientId, 'client-001');
      expect(dog.name, 'Buddy');
      expect(dog.breed, 'Labrador Retriever');
      expect(dog.breedId, 'breed-labrador-retriever');
      expect(dog.breedName, 'Labrador Retriever');
      expect(dog.sex, 'male');
      expect(dog.neutered, isTrue);
      expect(dog.dateOfBirth, '2020-05-15');
      expect(dog.colour, 'Golden');
      expect(dog.microchipNumber, '900000000000001');
      expect(dog.veterinaryPractice, 'Main Street Vets');
      expect(dog.medicalNotes, 'Allergy to chicken');
      expect(dog.behaviouralNotes, 'Friendly with other dogs');
      expect(dog.feedingNotes, 'Twice daily, grain-free');
      expect(dog.avatarObjectKey, 'dogs/550e8400-e29b-41d4-a716-446655440000/avatar/original.jpg');
      expect(dog.profilePhotoObjectKey, 'dogs/550e8400-e29b-41d4-a716-446655440000/profile/original.jpg');
      expect(dog.nosePrintObjectKey, 'dogs/550e8400-e29b-41d4-a716-446655440000/nose-print/original.jpg');
      expect(dog.allergies, isTrue);
      expect(dog.allergiesNotes, 'Chicken protein');
      expect(dog.medication, isTrue);
      expect(dog.medicationNotes, 'Glucosamine daily');
      expect(dog.vetPracticeId, 'vet-001');
      expect(dog.vetPracticeName, 'Main Street Vets');
      expect(dog.energyLevel, 'medium');
      expect(dog.leashManners, 'good');
      expect(dog.recallRating, 'excellent');
      expect(dog.aggressive, isFalse);
      expect(dog.muzzleRequired, isFalse);
      expect(dog.specialCommands, 'Hand signal for sit');
      expect(dog.walkingGearObjectKey, 'dogs/550e8400-e29b-41d4-a716-446655440000/gear/original.jpg');
      expect(dog.gearLocation, 'Hooks by back door');
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
        'breed_id': null,
        'breed_name': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'avatar_object_key': null,
        'profile_photo_object_key': null,
        'nose_print_object_key': null,
        'allergies': 0,
        'allergies_notes': null,
        'medication': 0,
        'medication_notes': null,
        'vet_practice_id': null,
        'vet_practice_name': null,
        'energy_level': null,
        'leash_manners': null,
        'recall_rating': null,
        'aggressive': 0,
        'muzzle_required': 0,
        'special_commands': null,
        'walking_gear_object_key': null,
        'gear_location': null,
        'archived_at': null,
        'created_at': '2024-06-01T00:00:00.000Z',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.id, 'min-id');
      expect(dog.clientId, 'client-002');
      expect(dog.name, 'Rex');
      expect(dog.breed, isNull);
      expect(dog.breedId, isNull);
      expect(dog.breedName, isNull);
      expect(dog.sex, isNull);
      expect(dog.neutered, isFalse);
      expect(dog.dateOfBirth, isNull);
      expect(dog.colour, isNull);
      expect(dog.microchipNumber, isNull);
      expect(dog.veterinaryPractice, isNull);
      expect(dog.medicalNotes, isNull);
      expect(dog.behaviouralNotes, isNull);
      expect(dog.feedingNotes, isNull);
      expect(dog.avatarObjectKey, isNull);
      expect(dog.profilePhotoObjectKey, isNull);
      expect(dog.nosePrintObjectKey, isNull);
      expect(dog.allergies, isFalse);
      expect(dog.allergiesNotes, isNull);
      expect(dog.medication, isFalse);
      expect(dog.medicationNotes, isNull);
      expect(dog.vetPracticeId, isNull);
      expect(dog.vetPracticeName, isNull);
      expect(dog.energyLevel, isNull);
      expect(dog.leashManners, isNull);
      expect(dog.recallRating, isNull);
      expect(dog.aggressive, isFalse);
      expect(dog.muzzleRequired, isFalse);
      expect(dog.specialCommands, isNull);
      expect(dog.walkingGearObjectKey, isNull);
      expect(dog.gearLocation, isNull);
      expect(dog.archivedAt, isNull);
    });

    test('handles missing new fields for backward compatibility', () {
      final json = <String, dynamic>{
        'id': 'legacy-id',
        'client_id': 'client-legacy',
        'name': 'OldDog',
        'breed': null,
        'breed_id': null,
        'breed_name': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'avatar_object_key': null,
        'profile_photo_object_key': null,
        'nose_print_object_key': null,
        'archived_at': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final dog = Dog.fromJson(json);

      expect(dog.allergies, isFalse);
      expect(dog.medication, isFalse);
      expect(dog.aggressive, isFalse);
      expect(dog.muzzleRequired, isFalse);
      expect(dog.vetPracticeId, isNull);
      expect(dog.energyLevel, isNull);
      expect(dog.gearLocation, isNull);
    });

    test('parses archived dog', () {
      final json = <String, dynamic>{
        'id': 'archived-id',
        'client_id': 'client-003',
        'name': 'Retired Rover',
        'breed': null,
        'breed_id': null,
        'breed_name': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'avatar_object_key': null,
        'profile_photo_object_key': null,
        'nose_print_object_key': null,
        'allergies': 0,
        'allergies_notes': null,
        'medication': 0,
        'medication_notes': null,
        'vet_practice_id': null,
        'vet_practice_name': null,
        'energy_level': null,
        'leash_manners': null,
        'recall_rating': null,
        'aggressive': 0,
        'muzzle_required': 0,
        'special_commands': null,
        'walking_gear_object_key': null,
        'gear_location': null,
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
        'breed_id': null,
        'breed_name': null,
        'sex': null,
        'neutered': 0,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'avatar_object_key': null,
        'profile_photo_object_key': null,
        'nose_print_object_key': null,
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
        'breed_id': null,
        'breed_name': null,
        'sex': null,
        'neutered': 1,
        'date_of_birth': null,
        'colour': null,
        'microchip_number': null,
        'veterinary_practice': null,
        'medical_notes': null,
        'behavioural_notes': null,
        'feeding_notes': null,
        'avatar_object_key': null,
        'profile_photo_object_key': null,
        'nose_print_object_key': null,
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
        breedId: 'breed-labrador-retriever',
        breedName: 'Labrador Retriever',
        sex: 'male',
        neutered: true,
        dateOfBirth: '2020-05-15',
        colour: 'Golden',
        microchipNumber: '900000000000001',
        veterinaryPractice: 'Main Street Vets',
        medicalNotes: 'Healthy',
        behaviouralNotes: 'Friendly',
        feedingNotes: 'Twice daily',
        allergies: true,
        allergiesNotes: 'Chicken',
        medication: true,
        medicationNotes: 'Glucosamine',
        vetPracticeId: 'vet-001',
        vetPracticeName: 'Main Street Vets',
        energyLevel: 'medium',
        leashManners: 'good',
        recallRating: 'excellent',
        aggressive: false,
        muzzleRequired: false,
        specialCommands: 'Sit hand signal',
        gearLocation: 'By the door',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-02-01T00:00:00.000Z',
      );

      final json = dog.toJson();

      expect(json['id'], 'test-id');
      expect(json['client_id'], 'client-001');
      expect(json['name'], 'Buddy');
      expect(json['breed'], 'Labrador');
      expect(json['breed_id'], 'breed-labrador-retriever');
      expect(json['breed_name'], 'Labrador Retriever');
      expect(json['sex'], 'male');
      expect(json['neutered'], 1);
      expect(json['date_of_birth'], '2020-05-15');
      expect(json['colour'], 'Golden');
      expect(json['microchip_number'], '900000000000001');
      expect(json['veterinary_practice'], 'Main Street Vets');
      expect(json['medical_notes'], 'Healthy');
      expect(json['behavioural_notes'], 'Friendly');
      expect(json['feeding_notes'], 'Twice daily');
      expect(json['avatar_object_key'], isNull);
      expect(json['profile_photo_object_key'], isNull);
      expect(json['nose_print_object_key'], isNull);
      expect(json['allergies'], 1);
      expect(json['allergies_notes'], 'Chicken');
      expect(json['medication'], 1);
      expect(json['medication_notes'], 'Glucosamine');
      expect(json['vet_practice_id'], 'vet-001');
      expect(json['vet_practice_name'], 'Main Street Vets');
      expect(json['energy_level'], 'medium');
      expect(json['leash_manners'], 'good');
      expect(json['recall_rating'], 'excellent');
      expect(json['aggressive'], 0);
      expect(json['muzzle_required'], 0);
      expect(json['special_commands'], 'Sit hand signal');
      expect(json['walking_gear_object_key'], isNull);
      expect(json['gear_location'], 'By the door');
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

    test('boolean fields serialise to integer', () {
      const dog = Dog(
        id: 'id',
        clientId: 'c',
        name: 'N',
        neutered: false,
        allergies: true,
        medication: false,
        aggressive: true,
        muzzleRequired: true,
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      final json = dog.toJson();
      expect(json['allergies'], 1);
      expect(json['medication'], 0);
      expect(json['aggressive'], 1);
      expect(json['muzzle_required'], 1);
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
      expect(json['breed_id'], isNull);
      expect(json['breed_name'], isNull);
      expect(json['sex'], isNull);
      expect(json['date_of_birth'], isNull);
      expect(json['colour'], isNull);
      expect(json['microchip_number'], isNull);
      expect(json['veterinary_practice'], isNull);
      expect(json['medical_notes'], isNull);
      expect(json['behavioural_notes'], isNull);
      expect(json['feeding_notes'], isNull);
      expect(json['avatar_object_key'], isNull);
      expect(json['profile_photo_object_key'], isNull);
      expect(json['nose_print_object_key'], isNull);
      expect(json['allergies_notes'], isNull);
      expect(json['medication_notes'], isNull);
      expect(json['vet_practice_id'], isNull);
      expect(json['vet_practice_name'], isNull);
      expect(json['energy_level'], isNull);
      expect(json['leash_manners'], isNull);
      expect(json['recall_rating'], isNull);
      expect(json['special_commands'], isNull);
      expect(json['walking_gear_object_key'], isNull);
      expect(json['gear_location'], isNull);
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
        'breed_id': 'breed-poodle',
        'breed_name': 'Poodle',
        'sex': 'female',
        'neutered': 1,
        'date_of_birth': '2019-08-20',
        'colour': 'White',
        'microchip_number': '900000000000002',
        'veterinary_practice': 'Park Vets',
        'medical_notes': 'Hip check due',
        'behavioural_notes': 'Nervous around cats',
        'feeding_notes': 'Once daily',
        'avatar_object_key': 'dogs/round-trip-id/avatar/original.jpg',
        'profile_photo_object_key': 'dogs/round-trip-id/profile/original.jpg',
        'nose_print_object_key': 'dogs/round-trip-id/nose-print/original.jpg',
        'allergies': 1,
        'allergies_notes': 'Grass pollen',
        'medication': 1,
        'medication_notes': 'Antihistamine',
        'vet_practice_id': 'vet-park',
        'vet_practice_name': 'Park Vets',
        'energy_level': 'high',
        'leash_manners': 'fair',
        'recall_rating': 'good',
        'aggressive': 0,
        'muzzle_required': 0,
        'special_commands': 'Come',
        'walking_gear_object_key': 'dogs/round-trip-id/gear/original.jpg',
        'gear_location': 'Hall closet',
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
