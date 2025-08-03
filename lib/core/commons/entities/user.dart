class User {
  final String id;
  final String email;
  final String name; // or replace with firstName & lastName if needed

  const User({
    required this.id,
    required this.email,
    required this.name,
  });
}
