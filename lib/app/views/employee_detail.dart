import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee worker;

  const EmployeeDetailPage({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('פרטי עובד')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person, size: 80),
            const SizedBox(height: 20),
            Text('שם: ${worker.name}', style: const TextStyle(fontSize: 18)),
            Text('תפקיד: ${worker.duty}', style: const TextStyle(fontSize: 18)),
            Text('טלפון: ${worker.phone}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
