class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
