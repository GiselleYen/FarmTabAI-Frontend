// models/organization.dart
class Organization {
  final String id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Organization({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'].toString(),
      name: json['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}