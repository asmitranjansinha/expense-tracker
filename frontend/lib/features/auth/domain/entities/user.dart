class User {
  final String id;
  final String name;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] ?? json['user']['_id'] ?? '',
      name: json['user']['name'] ?? '',
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
