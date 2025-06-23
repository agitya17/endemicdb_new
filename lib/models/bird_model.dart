// models/bird_model.dart
class Bird {
  final int? id;
  final String name;
  final String scientificName;
  final String imageUrl;
  final String description;
  final String habitat;
  final String conservationStatus;
  bool isFavorite;

  Bird({
    this.id,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.description,
    required this.habitat,
    required this.conservationStatus,
    this.isFavorite = false,
  });

  // Konversi dari JSON API
  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      name: json['common_name'] ?? 'N/A',
      scientificName: json['scientific_name'] ?? 'N/A',
      imageUrl: json['media'] != null && json['media'].isNotEmpty
          ? json['media'][0]['url']
          : "https://via.placeholder.com/150",
      description: json['description'] ?? 'No description available.',
      habitat: json['habitat'] ?? 'Unknown',
      conservationStatus: json['conservation_status'] ?? 'Not evaluated',
      isFavorite: false,
    );
  }

  // Konversi ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'image_url': imageUrl,
      'description': description,
      'habitat': habitat,
      'conservation_status': conservationStatus,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  // Konversi dari Map (dari database)
  factory Bird.fromMap(Map<String, dynamic> map) {
    return Bird(
      id: map['id'],
      name: map['name'],
      scientificName: map['scientific_name'],
      imageUrl: map['image_url'],
      description: map['description'],
      habitat: map['habitat'],
      conservationStatus: map['conservation_status'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}