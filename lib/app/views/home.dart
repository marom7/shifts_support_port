//import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home.dart';
import 'shift.dart';
import 'employees.dart';
import 'settings.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'ניהול משמרות ${getMonthName(DateTime.now().month)}-${DateTime.now().year}';
    return Scaffold(
      appBar: AppBar(title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])), centerTitle: true),
      body: Obx(
        () => IndexedStack(
          index: Get.put(HomeController()).currentIndex.value,
          children: [ShiftPage(), EmployeeGridPage(), const SettingsPage() ],
          //const SettingsPage() 
          //UserPermissionScreen()
          //const UserTableScreen()
          //const SettingsPage()
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

  String getMonthName(int month) {
    const monthNames = [
      'ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני',
      'יולי', 'אוגוסט', 'ספטמבר', 'אוקטובר', 'נובמבר', 'דצמבר'
    ];
    return monthNames[month - 1];
  }
}

//import 'user_permissions_list_view.dart';
//import 'user_table.dart';

//import 'package:google_fonts/google_fonts.dart';
