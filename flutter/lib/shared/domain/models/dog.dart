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
      'archived_at': archivedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
