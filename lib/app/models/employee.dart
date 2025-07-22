class Employee {
  final int id;
  final String name;
  final String duty;
  final String email;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.duty,
    required this.email,
    required this.phone,
  });

  factory Employee.fromJson(int id, Map<String, dynamic> json) {
    return Employee(
      id: id,
      name: json['name'],
      duty: json['duty'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duty': duty,
      'email': email,
      'phone': phone,
    };
  }
}