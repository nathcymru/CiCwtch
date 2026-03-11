class Dog {
  const Dog({
    required this.id,
    required this.clientId,
    required this.name,
    this.breed,
    this.breedId,
    this.breedName,
    this.sex,
    required this.neutered,
    this.dateOfBirth,
    this.colour,
    this.microchipNumber,
    this.veterinaryPractice,
    this.medicalNotes,
    this.behaviouralNotes,
    this.feedingNotes,
    this.avatarObjectKey,
    this.profilePhotoObjectKey,
    this.nosePrintObjectKey,
    this.allergies = false,
    this.allergiesNotes,
    this.medication = false,
    this.medicationNotes,
    this.vetPracticeId,
    this.vetPracticeName,
    this.energyLevel,
    this.leashManners,
    this.recallRating,
    this.aggressive = false,
    this.muzzleRequired = false,
    this.specialCommands,
    this.walkingGearObjectKey,
    this.gearLocation,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String clientId;
  final String name;
  final String? breed;
  final String? breedId;
  final String? breedName;
  final String? sex;
  final bool neutered;
  final String? dateOfBirth;
  final String? colour;
  final String? microchipNumber;
  final String? veterinaryPractice;
  final String? medicalNotes;
  final String? behaviouralNotes;
  final String? feedingNotes;
  final String? avatarObjectKey;
  final String? profilePhotoObjectKey;
  final String? nosePrintObjectKey;
  final bool allergies;
  final String? allergiesNotes;
  final bool medication;
  final String? medicationNotes;
  final String? vetPracticeId;
  final String? vetPracticeName;
  final String? energyLevel;
  final String? leashManners;
  final String? recallRating;
  final bool aggressive;
  final bool muzzleRequired;
  final String? specialCommands;
  final String? walkingGearObjectKey;
  final String? gearLocation;
  final String? archivedAt;
  final String createdAt;
  final String updatedAt;

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String?,
      breedId: json['breed_id'] as String?,
      breedName: json['breed_name'] as String?,
      sex: json['sex'] as String?,
      neutered: (json['neutered'] as int) == 1,
      dateOfBirth: json['date_of_birth'] as String?,
      colour: json['colour'] as String?,
      microchipNumber: json['microchip_number'] as String?,
      veterinaryPractice: json['veterinary_practice'] as String?,
      medicalNotes: json['medical_notes'] as String?,
      behaviouralNotes: json['behavioural_notes'] as String?,
      feedingNotes: json['feeding_notes'] as String?,
      avatarObjectKey: json['avatar_object_key'] as String?,
      profilePhotoObjectKey: json['profile_photo_object_key'] as String?,
      nosePrintObjectKey: json['nose_print_object_key'] as String?,
      allergies: (json['allergies'] as int? ?? 0) == 1,
      allergiesNotes: json['allergies_notes'] as String?,
      medication: (json['medication'] as int? ?? 0) == 1,
      medicationNotes: json['medication_notes'] as String?,
      vetPracticeId: json['vet_practice_id'] as String?,
      vetPracticeName: json['vet_practice_name'] as String?,
      energyLevel: json['energy_level'] as String?,
      leashManners: json['leash_manners'] as String?,
      recallRating: json['recall_rating'] as String?,
      aggressive: (json['aggressive'] as int? ?? 0) == 1,
      muzzleRequired: (json['muzzle_required'] as int? ?? 0) == 1,
      specialCommands: json['special_commands'] as String?,
      walkingGearObjectKey: json['walking_gear_object_key'] as String?,
      gearLocation: json['gear_location'] as String?,
      archivedAt: json['archived_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'name': name,
      'breed': breed,
      'breed_id': breedId,
      'breed_name': breedName,
      'sex': sex,
      'neutered': neutered ? 1 : 0,
      'date_of_birth': dateOfBirth,
      'colour': colour,
      'microchip_number': microchipNumber,
      'veterinary_practice': veterinaryPractice,
      'medical_notes': medicalNotes,
      'behavioural_notes': behaviouralNotes,
      'feeding_notes': feedingNotes,
      'avatar_object_key': avatarObjectKey,
      'profile_photo_object_key': profilePhotoObjectKey,
      'nose_print_object_key': nosePrintObjectKey,
      'allergies': allergies ? 1 : 0,
      'allergies_notes': allergiesNotes,
      'medication': medication ? 1 : 0,
      'medication_notes': medicationNotes,
      'vet_practice_id': vetPracticeId,
      'vet_practice_name': vetPracticeName,
      'energy_level': energyLevel,
      'leash_manners': leashManners,
      'recall_rating': recallRating,
      'aggressive': aggressive ? 1 : 0,
      'muzzle_required': muzzleRequired ? 1 : 0,
      'special_commands': specialCommands,
      'walking_gear_object_key': walkingGearObjectKey,
      'gear_location': gearLocation,
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
