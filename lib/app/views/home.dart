import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home.dart';
import 'shift.dart';
import 'employees.dart';
import 'settings.dart';
import 'users_permit.dart';
//import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ניהול משמרות'), centerTitle: true),
      body: Obx(
        () => IndexedStack(
          index: Get.put(HomeController()).currentIndex.value,
          children: [ShiftPage(), EmployeeGridPage(), const SettingsPage()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: const Color(0xFFFFA726), // כתום
          unselectedItemColor: const Color(0xFF757575), // אפור
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'משמרות',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'עובדים'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'הגדרות',
            ),
          ],
        ),
      ),
    );
  }
}
