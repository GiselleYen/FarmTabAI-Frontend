class User {
  final String id;
  final String name;
  final String email;
  String? organizationId;
  String role;
  final String? bio;
  final String? username;
  final String? profileImageUrl;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.organizationId,
    this.role = 'user',
    this.bio,
    this.username,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id']?.toString() ?? '',
      name: json['username']?.toString() ?? '', // ← FIXED here
      email: json['email']?.toString() ?? '',
      organizationId: json['organization_id']?.toString(),
      role: json['role']?.toString() ?? 'user',
      bio: json['bio']?.toString(),
      username: json['username']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'organization_id': organizationId,
      'role': role,
      'bio': bio,
      'username': username,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}