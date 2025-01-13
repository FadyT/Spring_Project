class Employee {
  final int id;
  final String name;
  final String username;
  final String email;

  Employee({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
    };
  }
}
