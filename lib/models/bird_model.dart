class Bird {
  final int? id;
  final String name;
  final String scientificName;
  final String imageUrl;
  final String description;
  final String habitat;
  final String conservationStatus;

  Bird({
    this.id,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.description,
    required this.habitat,
    required this.conservationStatus,
  });

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientific_name'],
      imageUrl: json['image_url'],
      description: json['description'],
      habitat: json['habitat'],
      conservationStatus: json['conservation_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'image_url': imageUrl,
      'description': description,
      'habitat': habitat,
      'conservation_status': conservationStatus,
    };
  }
}