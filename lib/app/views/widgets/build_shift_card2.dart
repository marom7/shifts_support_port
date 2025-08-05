import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifts_employees/app/models/employee.dart';
import 'package:shifts_employees/app/views/widgets/dropdown_row.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/controllers/employee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildShiftCard(String title, String initialHd, String initialIt,
    void Function(String) onchangedHd, void Function(String) onchangedIt) {
  final EmployeeController controller = Get.put(EmployeeController());

  final List<Employee> techs = controller.getEmployeesByDuty(['טכנאי', 'מפעיל מחשב']);
  final List<Employee> managers = controller.getEmployeesByDuty(['מנהל רשת', 'סייבר']);

  if (controller.employees.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  return StatefulBuilder(
    builder: (context, setState) {
      // שמירת הערכים הנוכחיים במצב מקומי
      String currentHd = initialHd;
      String currentIt = initialIt;

      Future<void> sendWhatsApp(Employee employee) async {
        try {
          String waPhone = employee.phone.replaceAll('-', '').replaceFirst('0', '972', 0);
          String defaultMessage = "שלום ${employee.name}, ";
          String uri = "https://wa.me/$waPhone?text=${Uri.encodeComponent(defaultMessage)}";
          
          if (await canLaunchUrl(Uri.parse(uri))) {
            await launchUrl(Uri.parse(uri));
          } else {
            Get.snackbar('שגיאה', 'לא ניתן לפתוח את WhatsApp');
          }
        } catch (e) {
          Get.snackbar('שגיאה', 'בעיה בשליחת הודעה: ${e.toString()}');
        }
      }

      Future<void> makeCall(Employee employee) async {
        try {
          final Uri telUri = Uri(scheme: 'tel', path: employee.phone);
          if (await canLaunchUrl(telUri)) {
            await launchUrl(telUri);
          } else {
            Get.snackbar('שגיאה', 'לא ניתן לבצע שיחה');
          }
        } catch (e) {
          Get.snackbar('שגיאה', 'בעיה בחיוג: ${e.toString()}');
        }
      }

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        color: title == 'משמרת בוקר'
            ? const Color.fromARGB(255, 79, 198, 182)   //  משמרת בוקר
            : const Color.fromARGB(255, 41, 158, 212),  //  משמרת ערב  
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
              const SizedBox(height: 12),
              
              // HD Row
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      currentHd.obs, 
                      techs.map((e) => e.name).toList(), 
                      (newValue) {
                        setState(() => currentHd = newValue);
                        onchangedHd(newValue);
                      }
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      // WhatsApp Button
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.whatsapp, size: 28),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final employee = techs.firstWhere((e) => e.name == currentHd);
                          sendWhatsApp(employee);
                        },
                      ),
                      const SizedBox(width: 8),
                      
                      // Phone Button
                      IconButton(
                        icon: const Icon(Icons.phone, size: 28),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final employee = techs.firstWhere((e) => e.name == currentHd);
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
                      currentIt.obs, 
                      managers.map((e) => e.name).toList(), 
                      (newValue) {
                        setState(() => currentIt = newValue);
                        onchangedIt(newValue);
                      }
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      // WhatsApp Button
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.whatsapp, size: 28),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final employee = managers.firstWhere((e) => e.name == currentIt);
                          sendWhatsApp(employee);
                        },
                      ),
                      const SizedBox(width: 8),
                      
                      // Phone Button
                      IconButton(
                        icon: const Icon(Icons.phone, size: 28),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final employee = managers.firstWhere((e) => e.name == currentIt);
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
  );
}