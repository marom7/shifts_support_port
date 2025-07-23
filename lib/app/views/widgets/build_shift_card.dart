import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/models/employee.dart';
import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import '/app/controllers/employee.dart';

Widget buildShiftCard(String title, String hd, String it,
    void Function(String) onchangedHd, void Function(String) onchangedIt) {
  final EmployeeController controller = Get.put(EmployeeController());
 
  final List<Employee> techs = controller.getEmployeesByDuty(['טכנאי', 'מפעיל מחשב']);
  final List<Employee> managers = controller.getEmployeesByDuty(['מנהל רשת', 'סייבר']);
      
  if (controller.employees.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.all(8),
    color: title== 'משמרת בוקר'? const Color.fromARGB(255, 79, 198, 182): const Color.fromARGB(255, 41, 158, 212),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          buildDropdown(hd.obs, techs.map((e) => e.name).toList(), onchangedHd),
          const SizedBox(height: 8),
          buildDropdown(it.obs, managers.map((e) => e.name).toList(), onchangedIt),
        ],
      ),
    ),
  );
}

