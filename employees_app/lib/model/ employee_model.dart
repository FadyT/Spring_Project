class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
