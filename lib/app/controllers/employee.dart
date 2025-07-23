// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/employee.dart';

class EmployeeController extends GetxController {
  var employees = <Employee>[].obs;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('employees');

  @override
  void onInit() {
    super.onInit();
    fetchEmployeesFromFirebase();
  }

  void fetchEmployeesFromFirebase() async {
    
    final snapshot = await _dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final parsed = data.entries.map((entry) {
        return Employee.fromJson(
            entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();

      employees.assignAll(parsed);
    }
    else {
      print('No data available');
    }
  }
  
  Employee? getEmployeeByName(String name) {
    return employees.firstWhereOrNull((e) => e.name == name);
  }

  List<Employee> getEmployeesByDuty(List<String> duties) {
    return employees.where((e) => duties.contains(e.duty)).toList();
  }
}