class Breed {
  const Breed({
    required this.breedId,
    required this.breedName,
  });

  final String breedId;
  final String breedName;

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      breedId: json['breed_id'] as String,
      breedName: json['breed_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breed_id': breedId,
      'breed_name': breedName,
    };
  }
}
