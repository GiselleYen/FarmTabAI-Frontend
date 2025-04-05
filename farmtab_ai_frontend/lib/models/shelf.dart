class Shelf {
  final int id;
  final String name;
  final String subtitle;
  final String shelfImageUrl;
  final String plantType;
  final int harvestDays;
  final int farmId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavourite;
  final int passedDays;

  Shelf({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.shelfImageUrl,
    required this.plantType,
    required this.harvestDays,
    required this.passedDays,
    required this.farmId,
    required this.createdAt,
    required this.updatedAt,
    this.isFavourite = false,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      shelfImageUrl: json['shelf_image_url'],
      plantType: json['plant_type'],
      harvestDays: json['harvest_days'],
      passedDays: json['passed_days'] ?? 0,
      farmId: json['farm_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isFavourite: json['is_favourite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subtitle': subtitle,
      'shelf_image_url': shelfImageUrl,
      'plant_type': plantType,
      'harvest_days': harvestDays,
      'passed_days': passedDays,
      'farm_id': farmId,
      'is_favourite': isFavourite,
    };
  }
}
