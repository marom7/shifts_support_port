import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee.dart';
import 'employee_detail.dart';

class EmployeeGridPage extends StatelessWidget {
  final EmployeeController controller = Get.put(EmployeeController());

  EmployeeGridPage({super.key});

  Color getRoleColor(String role) {
     if (role == 'מנהל רשת') return Colors.blue.shade100;
     if (role == 'טכנאי') Colors.green.shade100;
     if (role == 'סייבר') return const Color.fromARGB(255, 255, 190, 178);
     if (role == 'מפעיל מחשב') return const Color.fromARGB(255, 191, 216, 236);
     return Colors.grey.shade200; // צבע ברירת מחדל
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('רשימת עובדים')),
      body: Obx(() {
        if (controller.employees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: controller.employees.length,
          itemBuilder: (context, index) {
            final worker = controller.employees[index];
            return GestureDetector(
              onTap: () => Get.to(() => EmployeeDetailPage(worker: worker)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: getRoleColor(worker.duty),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5)
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 40),
                    const SizedBox(height: 8),
                    Text(worker.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(worker.duty),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/*
import 'package:flutter/material.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // ירוק בהיר
      body: Center(
        child: Text(
          'מסך עובדים',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
*/
