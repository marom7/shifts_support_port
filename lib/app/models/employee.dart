class Employee {
  final String name;
  final String duty;
  final String email;
  final String phone;

  Employee({
    required this.name,
    required this.duty,
    required this.email,
    required this.phone,
  });

  factory Employee.fromJson(String name, Map<String, dynamic> json) {
    return Employee(
      name: name,
      duty: json['duty'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duty': duty,
      'email': email,
      'phone': phone,
    };
  }
}