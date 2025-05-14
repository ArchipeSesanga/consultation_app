class Lecturer {
  final String id;
  final String name;
  final String email;
  final String module;

  Lecturer({
    required this.id,
    required this.name,
    required this.email,
    required this.module,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'module': module};
  }

  factory Lecturer.fromMap(Map<String, dynamic> map) {
    return Lecturer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      module: map['module'],
    );
  }
}
