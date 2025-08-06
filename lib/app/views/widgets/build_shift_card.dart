// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:shifts_employees/app/Utils/phone_utiles.dart';
import 'package:shifts_employees/app/models/employee.dart';
import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import '/app/controllers/employee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import 'package:url_launcher/url_launcher.dart';
Widget buildShiftCard(
  String title,
  RxString hd,            // <-- היה String
  RxString it,            // <-- היה String
  void Function(String) onChangedHd,
  void Function(String) onChangedIt,
) {
  final EmployeeController controller = Get.put(EmployeeController());

  final List<Employee> techs = controller.getEmployeesByDuty(['טכנאי', 'מפעיל מחשב']);
  final List<Employee> managers = controller.getEmployeesByDuty(['מנהל רשת', 'סייבר']);

  if (controller.employees.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  // ברכה לפי השעה המקומית במכשיר
  String greetingByLocalTime([DateTime? now]) {
    final int h = (now ?? DateTime.now()).hour;
    if (h >= 5 && h < 12) return 'בוקר טוב';
    if (h >= 12 && h < 16) return 'צהריים טובים';
    if (h >= 16 && h < 22) return 'ערב טוב';
    return 'שלום'; // לילה/שעות מאוחרות
  }

  // בניית טקסט לוואטסאפ כולל ברכה ושם העובד
  String buildWaMessageForEmployee(Employee e, {String? extra}) {
    final g = greetingByLocalTime();
    return '$g ${e.name}, ${extra ?? ''}';
  }

  Future<void> sendWhatsApp(Employee employee) async {
    try {
      final waPhone = employee.phone.replaceAll('-', '').replaceFirst(RegExp(r'^0'), '972');
      String defaultMessage = buildWaMessageForEmployee(employee, extra: 'יש תקלה');
      final uri = Uri.parse("https://wa.me/$waPhone?text=${Uri.encodeComponent(defaultMessage)}");
      //if (await 
      //canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      //} else {
      // Get.snackbar('שגיאה', 'לא ניתן לפתוח את WhatsApp');
      
    } catch (e) {
      Get.snackbar('שגיאה', 'בעיה בשליחת הודעה: ${e.toString()}');
    }
  }

  Future<void> makeCall(Employee employee) async {
    try {
      final telUri = Uri(scheme: 'tel', path: employee.phone);
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        Get.snackbar('שגיאה', 'לא ניתן לבצע שיחה');
      }
    } catch (e) {
      Get.snackbar('שגיאה', 'בעיה בחיוג: ${e.toString()}');
    }
  }

  Employee _findByName(List<Employee> list, String name) =>
      list.firstWhere((e) => e.name == name);

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.all(8),
    color: title == 'משמרת בוקר'
        ? const Color.fromARGB(255, 79, 198, 182)
        : const Color.fromARGB(255, 41, 158, 212),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),

          // HD Row
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  hd,       // <-- מעבירים RxString אמיתי
                  techs.map((e) => e.name).toList(),
                  (v) { hd.value = v; onChangedHd(v); },
                  label: "טכנאי" // <-- מעדכן Rx וגם קורא לקולבק
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp, size: 28),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (hd.value.isEmpty) return;
                      final employee = _findByName(techs, hd.value); // <-- הערך העדכני
                      sendWhatsApp(employee);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.phone, size: 28),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (hd.value.isEmpty) return;
                      final employee = _findByName(techs, hd.value); // <-- הערך העדכני
                      makeCall(employee);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // IT Row
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  it,
                  managers.map((e) => e.name).toList(),
                  (v) { it.value = v; onChangedIt(v); },
                  label: "מנהל רשת" // <-- מעדכן Rx וגם קורא לקולבק''
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp, size: 28),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (it.value.isEmpty) return;
                      final employee = _findByName(managers, it.value); // <-- הערך העדכני
                      sendWhatsApp(employee);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.phone, size: 28),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (it.value.isEmpty) return;
                      final employee = _findByName(managers, it.value); // <-- הערך העדכני
                      makeCall(employee);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
