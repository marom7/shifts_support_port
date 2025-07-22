class Employee {
   String? id;
   String name;
   String duty;
   String email;
   String phone;

  Employee({
    required this.id,
    required this.name,
    required this.duty,
    required this.email,
    required this.phone,
  });

  factory Employee.fromJson(Map<String, dynamic> json, {String? key}) {
    return Employee(
      id: key,
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