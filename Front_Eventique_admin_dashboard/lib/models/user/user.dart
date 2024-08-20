class User {
  final int? id;
  final String name;
  final String email;
  final List<String>? images;

  User({
    this.id,
    required this.name,
    required this.email,
    this.images,
  });
}