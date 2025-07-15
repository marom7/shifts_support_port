//import 'dart:ui' as radiuss;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/models/employee.dart';
import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import '/app/controllers/employee.dart';
// Adjust the import path as needed
//import 'dropdown_row.dart';
//List<Employee> employees = []; // Remove this line if 'employees' is already defined elsewhere and imported

Widget buildShiftCard(String title, String hd, String it,
    void Function(String) onchangedHd, void Function(String) onchangedIt) {
  final EmployeeController controller = Get.put(EmployeeController());
  //final items = ['דניאל', 'יוסי', 'טל', 'מארק', 'מרום', 'נועה'];
  //final emps = controller.employees.map((e) => e.name).toList();
  final List<Employee> techs = controller.getEmployeesByDuty('Technician');
  final List<Employee> managers =
      controller.getEmployeesByDuty('Network Manager');
  //.where((e) => e.duty == 'טכנאי' || e.duty == 'מנהל רשת')
  // .map((e) => e.name)controller.employees
  //.toList();
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



/*DropdownButtonFormField2<String>(
            value: val2.isEmpty ? null : val2,
            items: managers
                .map(
                    (e) => DropdownMenuItem(value: e.name, child: Text(e.name)))
                .toList(),
            onChanged: (val) => onChanged2(val ?? ''),
            decoration: const InputDecoration(
              labelText: 'מנהל רשת',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            dropdownStyleData: const DropdownStyleData(
              decoration: BoxDecoration(
                color: Color(0xFFE0F7FA),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),*/