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
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      // Convert the Map to a list of Employee objects
      final parsed = data.entries.map((entry) {
        return Employee.fromJson(entry.key,  // Use entry.key as the ID
             Map<String, dynamic>.from(entry.value));
      }).toList();

      employees.assignAll(parsed);
    }
  }

  Employee? getEmployeeByName(String name) {
    return employees.firstWhereOrNull((e) => e.name == name);
  }

  List<Employee> getEmployeesByDuty(String duty) {
    return employees.where((e) => e.duty == duty).toList();
  }
}