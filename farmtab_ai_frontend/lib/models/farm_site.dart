class Farm {
  final int? id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Farm({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}